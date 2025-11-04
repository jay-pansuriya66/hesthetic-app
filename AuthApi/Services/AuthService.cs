using AuthApi.Data;
using AuthApi.DTOs;
using AuthApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace AuthApi.Services;

public class AuthService : IAuthService
{
    private readonly AppDbContext _context;
    private readonly IConfiguration _configuration;

    public AuthService(AppDbContext context, IConfiguration configuration)
    {
        _context = context;
        _configuration = configuration;
    }

    public async Task<AuthResponse> RegisterAsync(RegisterDto registerDto)
    {
        // Check if username already exists
        if (await _context.Users.AnyAsync(u => u.Username == registerDto.Username))
        {
            return new AuthResponse
            {
                Success = false,
                Message = "Username already exists"
            };
        }

        // Check if email already exists
        if (await _context.Users.AnyAsync(u => u.Email == registerDto.Email))
        {
            return new AuthResponse
            {
                Success = false,
                Message = "Email already exists"
            };
        }

        // Hash password
        var passwordHash = BCrypt.Net.BCrypt.HashPassword(registerDto.Password);

        // Create user
        var user = new User
        {
            Username = registerDto.Username,
            Email = registerDto.Email,
            PasswordHash = passwordHash
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        // Generate token
        var token = GenerateJwtToken(user.Id, user.Username, user.Email);

        return new AuthResponse
        {
            Success = true,
            Message = "User registered successfully",
            Token = token,
            User = new UserDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email
            }
        };
    }

    public async Task<AuthResponse> LoginAsync(LoginDto loginDto)
    {
        // Find user by username or email
        var user = await _context.Users
            .FirstOrDefaultAsync(u => u.Username == loginDto.UsernameOrEmail || u.Email == loginDto.UsernameOrEmail);

        if (user == null)
        {
            return new AuthResponse
            {
                Success = false,
                Message = "Invalid credentials"
            };
        }

        // Verify password
        if (!BCrypt.Net.BCrypt.Verify(loginDto.Password, user.PasswordHash))
        {
            return new AuthResponse
            {
                Success = false,
                Message = "Invalid credentials"
            };
        }

        // Generate token
        var token = GenerateJwtToken(user.Id, user.Username, user.Email);

        return new AuthResponse
        {
            Success = true,
            Message = "Login successful",
            Token = token,
            User = new UserDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email
            }
        };
    }

    public async Task<AuthResponse> ValidateTokenAsync(string token)
    {
        try
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]!);

            tokenHandler.ValidateToken(token, new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = true,
                ValidIssuer = _configuration["Jwt:Issuer"],
                ValidateAudience = true,
                ValidAudience = _configuration["Jwt:Audience"],
                ValidateLifetime = true,
                ClockSkew = TimeSpan.Zero
            }, out SecurityToken validatedToken);

            var jwtToken = (JwtSecurityToken)validatedToken;
            var userId = int.Parse(jwtToken.Claims.First(x => x.Type == "userId").Value);
            var username = jwtToken.Claims.First(x => x.Type == "username").Value;
            var email = jwtToken.Claims.First(x => x.Type == "email").Value;

            return new AuthResponse
            {
                Success = true,
                Message = "Token is valid",
                Token = token,
                User = new UserDto
                {
                    Id = userId,
                    Username = username,
                    Email = email
                }
            };
        }
        catch
        {
            return new AuthResponse
            {
                Success = false,
                Message = "Invalid or expired token"
            };
        }
    }

    public string GenerateJwtToken(int userId, string username, string email)
    {
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]!));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new[]
        {
            new Claim("userId", userId.ToString()),
            new Claim("username", username),
            new Claim("email", email),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        var expiryDays = int.Parse(_configuration["Jwt:ExpiryInDays"]!);
        var token = new JwtSecurityToken(
            issuer: _configuration["Jwt:Issuer"],
            audience: _configuration["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddDays(expiryDays),
            signingCredentials: credentials
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
