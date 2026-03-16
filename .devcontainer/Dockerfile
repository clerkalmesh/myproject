FROM mcr.microsoft.com/devcontainers/base:ubuntu

USER root

# 1. Update & Install JDK 17 serta pendukungnya
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    unzip \
    curl \
    git \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

USER vscode
WORKDIR /home/vscode

# 2. Install Android SDK Command-line Tools
ENV ANDROID_HOME=/home/vscode/android-sdk
RUN mkdir -p $ANDROID_HOME/cmdline-tools \
    && curl -o sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    && unzip sdk.zip -d $ANDROID_HOME/cmdline-tools \
    && mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
    && rm sdk.zip

# Set Path Android
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools

# 3. Setujui Lisensi Android
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses

# 4. Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH=$PATH:/home/vscode/flutter/bin

# Inisialisasi Flutter
RUN flutter doctor
