using AuthApi.DTOs;
using AuthApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AuthApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    /// <summary>
    /// Register a new user
    /// </summary>
    [HttpPost("register")]
    public async Task<ActionResult<AuthResponse>> Register([FromBody] RegisterDto registerDto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(new AuthResponse
            {
                Success = false,
                Message = "Invalid data provided"
            });
        }

        var result = await _authService.RegisterAsync(registerDto);

        if (!result.Success)
        {
            return BadRequest(result);
        }

        return Ok(result);
    }

    /// <summary>
    /// Login with username/email and password, or validate existing token
    /// </summary>
    [HttpPost("login")]
    public async Task<ActionResult<AuthResponse>> Login([FromBody] LoginDto? loginDto)
    {
        // Check if Authorization header exists with a Bearer token
        var authHeader = Request.Headers["Authorization"].ToString();
        if (!string.IsNullOrEmpty(authHeader) && authHeader.StartsWith("Bearer "))
        {
            var token = authHeader.Substring("Bearer ".Length).Trim();
            var validationResult = await _authService.ValidateTokenAsync(token);

            if (validationResult.Success)
            {
                return Ok(validationResult);
            }
        }

        // If no valid token, proceed with normal login
        if (loginDto == null || !ModelState.IsValid)
        {
            return BadRequest(new AuthResponse
            {
                Success = false,
                Message = "Invalid credentials provided"
            });
        }

        var result = await _authService.LoginAsync(loginDto);

        if (!result.Success)
        {
            return Unauthorized(result);
        }

        return Ok(result);
    }

    /// <summary>
    /// Validate an existing JWT token
    /// </summary>
    [HttpPost("validate")]
    public async Task<ActionResult<AuthResponse>> ValidateToken([FromBody] TokenDto tokenDto)
    {
        if (string.IsNullOrEmpty(tokenDto.Token))
        {
            return BadRequest(new AuthResponse
            {
                Success = false,
                Message = "Token is required"
            });
        }

        var result = await _authService.ValidateTokenAsync(tokenDto.Token);

        if (!result.Success)
        {
            return Unauthorized(result);
        }

        return Ok(result);
    }

    /// <summary>
    /// Protected endpoint example - requires authentication
    /// </summary>
    [Authorize]
    [HttpGet("profile")]
    public ActionResult<object> GetProfile()
    {
        var userId = User.Claims.FirstOrDefault(c => c.Type == "userId")?.Value;
        var username = User.Claims.FirstOrDefault(c => c.Type == "username")?.Value;
        var email = User.Claims.FirstOrDefault(c => c.Type == "email")?.Value;

        return Ok(new
        {
            userId,
            username,
            email,
            message = "This is a protected endpoint"
        });
    }
}

public class TokenDto
{
    public string Token { get; set; } = string.Empty;
}
