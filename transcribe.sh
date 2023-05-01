#!/bin/bash

# Set your OpenAI API key
API_KEY="sk-"

# Set the path to the folder containing the audio files
AUDIO_FOLDER="$HOME/Desktop/folder"

# Loop through all the audio files in the folder
for audio_file in "$AUDIO_FOLDER"/*.{mp3,mp4,mpeg,mpga,m4a,wav,webm}; do
  # Use cURL to send the audio file to the OpenAI API for transcription
  response=$(curl -s -X POST -H "Content-Type: multipart/form-data" \
             -H "Authorization: Bearer $API_KEY" \
             -F "file=@$audio_file" \
             -F "model=whisper-1" \
             "https://api.openai.com/v1/audio/transcriptions")

  # Save the response to a JSON file
  echo "$response" > "${audio_file%.*}.json"

  # Print the transcription text or error message
  if [ "$(echo "$response" | jq -r '.error')" == "null" ]; then
    echo "$response" | jq -r '.text'
  else
    echo "Error: $(echo "$response" | jq -r '.error')"
  fi
done
