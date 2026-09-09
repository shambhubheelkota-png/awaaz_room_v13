buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// AGP 9.0 compatible clean task
tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory)
}
