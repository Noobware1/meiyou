// ignore_for_file: constant_identifier_names

enum InstallStep {
  Idle,
  Pending,
  Downloading,
  Installing,
  Installed,
  Error;

  bool get isCompleted => this == Installed || this == Error || this == Idle;
}
