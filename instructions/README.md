<h2>Instructions for installing dependencies</h2>

<h3>Implement user authentication using firebase</h3>
1. Add this to dev_dependencies in pubspec.yaml
```yaml
dev_dependencies:
    firebase_auth: ^4.1.4
    firebase_core: ^2.3.0
```
2. In android/build.gradle
```gradle
    dependencies {
        classpath 'com.google.gms:google-services:4.3.13'
    }
```
3. In android/app/build.gradle
```gradle
    apply plugin: 'com.google.gms.google-services'
    dependencies {
        implementation platform('com.google.firebase:firebase-bom:31.1.0')
    }
```
