import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_navigation.dart';
import 'firebase_bootstrap.dart';

const _bg = Color(0xFF08111D);
const _surface = Color(0xFF111E2D);
const _text = Color(0xFFF2F6FB);
const _muted = Color(0xFF8FA2B7);
const _accent = Color(0xFF52A8FF);

class AuthScreen extends StatefulWidget {
  final bool signupMode;

  const AuthScreen({
    super.key,
    this.signupMode = false,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  late bool _signupMode;
  bool _loading = false;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    _signupMode = widget.signupMode;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final validation = _validateCredentials(email: email, password: password);
    if (validation != null) {
      setState(() {
        _error = validation;
        _success = null;
      });
      return;
    }

    await _runAuthAction(
      action: () async {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      },
      afterSuccess: () {
        AppNavigation.goHome();
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    final validation = _validateCredentials(email: email, password: password);
    if (validation != null) {
      setState(() {
        _error = validation;
        _success = null;
      });
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        _error = 'Les mots de passe ne correspondent pas.';
        _success = null;
      });
      return;
    }

    final userName = _nameController.text.trim();
    if (userName.isEmpty) {
      setState(() {
        _error = 'Nom utilisateur obligatoire.';
        _success = null;
      });
      return;
    }

    await _runAuthAction(
      action: () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseAuth.instance.signOut();
        }

        final created = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await created.user?.updateDisplayName(userName);
        await FirebaseAuth.instance.signOut();
      },
      afterSuccess: () {
        setState(() {
          _signupMode = false;
          _error = null;
          _success = 'Compte cree. Connectez-vous maintenant avec vos identifiants.';
          _passwordController.clear();
          _confirmPasswordController.clear();
        });
      },
    );
  }

  Future<void> _runAuthAction({
    required Future<void> Function() action,
    VoidCallback? afterSuccess,
  }) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });

    try {
      await action();
      if (afterSuccess != null && mounted) {
        afterSuccess();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = _firebaseErrorMessage(e);
        _success = null;
      });
    } catch (_) {
      setState(() {
        _error = 'Une erreur est survenue.';
        _success = null;
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String? _validateCredentials({
    required String email,
    required String password,
  }) {
    if (email.isEmpty || password.isEmpty) {
      return 'Email et mot de passe sont obligatoires.';
    }
    if (!email.contains('@')) {
      return 'Email invalide.';
    }
    if (password.length < 6) {
      return 'Mot de passe trop court (minimum 6 caracteres).';
    }
    return null;
  }

  String _firebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'operation-not-allowed':
        return 'Activez Email/Password dans Firebase Authentication.';
      case 'email-already-in-use':
        return 'Cet email est deja utilise. Connectez-vous.';
      case 'invalid-email':
        return 'Format d email invalide.';
      case 'weak-password':
        return 'Mot de passe trop faible (minimum 6 caracteres).';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect.';
      case 'network-request-failed':
        return 'Connexion reseau indisponible.';
      default:
        return e.message ?? 'Erreur de connexion.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!FirebaseBootstrap.isEnabled) {
      return Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: const Color(0xFF243C55)),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connexion indisponible',
                        style: TextStyle(
                          color: _text,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Firebase n est pas configure localement. L application continue en mode local, mais la connexion et la synchronisation cloud sont desactivees.',
                        style: TextStyle(color: _muted, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final title = _signupMode ? 'Inscription' : 'Connexion';
    final subtitle = _signupMode
        ? 'Creez un compte pour sauvegarder et consulter vos sessions.'
        : 'Connectez-vous pour synchroniser vos sessions sur Firebase.';

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xFF243C55)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: _text,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(color: _muted),
                    ),
                    if (_signupMode) ...[
                      const SizedBox(height: 18),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: _text),
                        decoration: const InputDecoration(
                          labelText: 'Nom utilisateur',
                          labelStyle: TextStyle(color: _muted),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: _text),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: _muted),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: _text),
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: TextStyle(color: _muted),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (_signupMode) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: _text),
                        decoration: const InputDecoration(
                          labelText: 'Confirmer mot de passe',
                          labelStyle: TextStyle(color: _muted),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: const TextStyle(color: Color(0xFFFF6B78)),
                      ),
                    ],
                    if (_success != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _success!,
                        style: const TextStyle(color: Color(0xFF42C983)),
                      ),
                    ],
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: _loading ? null : (_signupMode ? _register : _signIn),
                      style: FilledButton.styleFrom(
                        backgroundColor: _accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _loading
                            ? 'Traitement...'
                            : (_signupMode ? 'Creer un compte' : 'Se connecter'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () {
                              setState(() {
                                _signupMode = !_signupMode;
                                _error = null;
                                _success = null;
                              });
                            },
                      child: Text(
                        _signupMode
                            ? 'Deja un compte ? Se connecter'
                            : 'Pas de compte ? Inscrivez-vous',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
