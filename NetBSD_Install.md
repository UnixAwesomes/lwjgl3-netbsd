# LWJGL3 On NetBSD

## Install the dependencies
```sh
pkgin install openjdk17 openjdk8 openjdk21 glfw libffi openal-soft MesaLib apache-ant jemalloc gtk3
```

## Clone the GitHub repository:
```sh
git clone https://github.com/UnixAwesomes/lwjgl3-netbsd/
cd lwjgl3-netbsd
````

## Configure JAVA_HOME
```sh
export JAVA_HOME=/usr/pkg/java/openjdk17
export JAVA8_HOME=/usr/pkg/java/openjdk8
```

## Building native libraries
```sh
ant compile-native-platform -Dplatform=netbsd
```

## Build jar files
```sh
ant compile-templates -Dplatform=netbsd
ant release -Dplatform=netbsd -Dbuild.offline=true
```
# Launching Minecraft

Use the patched-runtime.sh file, which uses the lwjgl jar files; it is available in the GitHub repository. Also, in the launcher, configure the path to the file





