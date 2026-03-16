FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install JDK 17 dan dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    unzip \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

USER vscode
WORKDIR /home/vscode

# Install Android SDK
ENV ANDROID_HOME=/home/vscode/android-sdk
RUN mkdir -p $ANDROID_HOME/cmdline-tools \
    && curl -o sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    && unzip sdk.zip -d $ANDROID_HOME/cmdline-tools \
    && mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
    && rm sdk.zip

ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Setujui Lisensi Android
RUN yes | sdkmanager --licenses

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH=$PATH:/home/vscode/flutter/bin

# Pre-download Flutter dependencies
RUN flutter doctor
