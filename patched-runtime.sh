#!/bin/sh

IS_MINECRAFT=0
for arg in "$@"; do
    case "$arg" in
        net.minecraft.client.main.Main) IS_MINECRAFT=1 ;;
    esac
done

if [ "$IS_MINECRAFT" = "0" ]; then
    exec /usr/pkg/java/openjdk17/bin/java "$@"
fi

ROOT=$HOME/lwjgl3-netbsd/bin/RELEASE
NATIVE_DIR=$HOME/lwjgl3-netbsd/native-netbsd

mkdir -p "$NATIVE_DIR"

find "$HOME/lwjgl3-netbsd/bin/libs/native/netbsd/x64/org/lwjgl" -name "*.so" -exec cp -f {} "$NATIVE_DIR/" \; 2>/dev/null

LWJGL_OVRD="${ROOT}/lwjgl/lwjgl.jar"
LWJGL_OGL_OVRD="${ROOT}/lwjgl-opengl/lwjgl-opengl.jar"
LWJGL_OAL_OVRD="${ROOT}/lwjgl-openal/lwjgl-openal.jar"
LWJGL_GLFW_OVRD="${ROOT}/lwjgl-glfw/lwjgl-glfw.jar"
LWJGL_STB_OVRD="${ROOT}/lwjgl-stb/lwjgl-stb.jar"
LWJGL_TINYFD_OVRD="${ROOT}/lwjgl-tinyfd/lwjgl-tinyfd.jar"
LWJGL_JEM_OVRD="${ROOT}/lwjgl-jemalloc/lwjgl-jemalloc.jar"
LWJGL_FREETYPE_OVRD="${ROOT}/lwjgl-freetype/lwjgl-freetype.jar"

export JAVA_HOME=/usr/pkg/java/openjdk21

MY_CP="${LWJGL_OVRD}:${LWJGL_GLFW_OVRD}:${LWJGL_OGL_OVRD}:${LWJGL_OAL_OVRD}:${LWJGL_STB_OVRD}:${LWJGL_TINYFD_OVRD}:${LWJGL_JEM_OVRD}:${LWJGL_FREETYPE_OVRD}"

new_args=""
cp_next=0
for arg in "$@"
do
    if [ "$cp_next" = "1" ]; then
        new_args="$new_args ${MY_CP}:${arg}"
        cp_next=0
    elif [ "$arg" = "-cp" ] || [ "$arg" = "-classpath" ]; then
        new_args="$new_args ${arg}"
        cp_next=1
    else
        new_args="$new_args ${arg}"
    fi
done

echo "NATIVE_DIR: ${NATIVE_DIR}" >&2
echo "FINAL ARGS: ${new_args}" >&2

env LD_LIBRARY_PATH=/usr/X11R7/lib:/usr/pkg/lib \
    ${JAVA_HOME}/bin/java \
    -Dorg.lwjgl.librarypath=${NATIVE_DIR}:/usr/pkg/lib:/usr/X11R7/lib \
    -Dorg.lwjgl.system.allocator=system \
    -Dorg.lwjgl.util.Debug=true \
    -Dorg.lwjgl.util.DebugLoader=true \
    ${new_args}
