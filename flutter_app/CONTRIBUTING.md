# Contributing to BitBirr

Thank you for your interest in contributing to BitBirr! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and encourage diverse perspectives
- Focus on what is best for the community
- Show empathy towards other community members

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- Clear, descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Device/OS information
- Flutter version

### Suggesting Features

We welcome feature suggestions! Please create an issue with:
- Clear description of the feature
- Use case and benefits
- Possible implementation approach (optional)

### Code Contributions

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Test thoroughly**
5. **Commit with clear messages**
   ```bash
   git commit -m "Add: feature description"
   ```
6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Create a Pull Request**

## Development Guidelines

### Code Style

We follow the official Flutter style guide:

```dart
// Good
class MyClass {
  final String name;
  final int age;
  
  MyClass({required this.name, required this.age});
}

// Bad
class myclass {
  String name;
  int age;
}
```

**Key Points:**
- Use `const` constructors where possible
- Prefer `final` for variables that don't change
- Use meaningful variable names
- Add comments for complex logic
- Follow Dart naming conventions:
  - Classes: `PascalCase`
  - Variables/methods: `camelCase`
  - Constants: `lowerCamelCase`
  - Files: `snake_case.dart`

### Code Formatting

Run before committing:
```bash
flutter format .
```

### Code Analysis

Ensure no errors or warnings:
```bash
flutter analyze
```

### Testing

All new features should include tests:
```bash
flutter test
```

### Project Structure

Follow the existing structure:
```
lib/
├── models/         # Data models
├── providers/      # State management
├── screens/        # UI screens
├── services/       # Backend services
├── utils/          # Helpers and utilities
└── widgets/        # Reusable widgets
```

## Commit Message Guidelines

Use clear, descriptive commit messages:

**Format:**
```
<type>: <subject>

<body (optional)>

<footer (optional)>
```

**Types:**
- `Add:` - New feature
- `Fix:` - Bug fix
- `Update:` - Update existing feature
- `Refactor:` - Code refactoring
- `Docs:` - Documentation changes
- `Style:` - Formatting, missing semicolons, etc.
- `Test:` - Adding tests
- `Chore:` - Maintenance tasks

**Examples:**
```bash
Add: email OTP authentication

Fix: order status not updating correctly

Update: improve payment instructions UI

Docs: add setup guide for Supabase
```

## Pull Request Guidelines

### Before Submitting

- [ ] Code is formatted (`flutter format .`)
- [ ] No analysis issues (`flutter analyze`)
- [ ] All tests pass (`flutter test`)
- [ ] New features have tests
- [ ] Documentation is updated
- [ ] Screenshots for UI changes

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe how you tested your changes

## Screenshots (if applicable)
Add screenshots here

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed my code
- [ ] Commented complex code
- [ ] Updated documentation
- [ ] No new warnings
- [ ] Added tests
- [ ] All tests pass
```

## Development Setup

1. **Install Flutter**
   ```bash
   # Follow official guide at flutter.dev
   ```

2. **Clone repository**
   ```bash
   git clone https://github.com/bitbirr/BitBirr.io.git
   cd BitBirr.io/flutter_app
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Configure Supabase**
   - Follow QUICKSTART.md

5. **Run the app**
   ```bash
   flutter run
   ```

## Areas for Contribution

### High Priority
- [ ] Real-time order updates
- [ ] Admin web panel
- [ ] Phone OTP authentication
- [ ] Push notifications
- [ ] KYC verification

### Medium Priority
- [ ] Dark mode
- [ ] Multiple languages (Amharic, Oromo)
- [ ] In-app chat support
- [ ] Transaction history export
- [ ] Price alerts

### Low Priority
- [ ] Biometric authentication
- [ ] Widget for quick buy
- [ ] Referral system
- [ ] Educational content
- [ ] FAQ section

## Security

If you discover a security vulnerability:
1. **DO NOT** create a public issue
2. Email security@bitbirr.io (if available)
3. Provide details about the vulnerability
4. Wait for response before disclosure

## Questions?

- Open an issue with the `question` label
- Check existing issues and documentation
- Review README.md and QUICKSTART.md

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project website (when available)

Thank you for contributing to BitBirr! 🚀
