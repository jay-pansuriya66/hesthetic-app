using AuthApi.DTOs;

namespace AuthApi.Services;

public interface IAuthService
{
    Task<AuthResponse> RegisterAsync(RegisterDto registerDto);
    Task<AuthResponse> LoginAsync(LoginDto loginDto);
    Task<AuthResponse> ValidateTokenAsync(string token);
    string GenerateJwtToken(int userId, string username, string email);
}
