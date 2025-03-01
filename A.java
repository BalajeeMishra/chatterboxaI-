signingConfigs {
    release {
        storeFile file("my-release-key.jks")
        storePassword "your-password"
        keyAlias "my-key-alias"
        keyPassword "your-key-password"
    }
}