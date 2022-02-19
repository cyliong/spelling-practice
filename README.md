# Spelling Practice
This is a cross-platform mobile app for Android and iOS, 
enabling students to practise spelling by themselves, 
using Text-to-Speech (TTS) technologies.

Based on the spelling list given by teachers or parents,
students add vocabularies to the app.
Then, they practise their spelling by asking the app to pronounce
the vocabularies one-by-one, and write down the vocabularies
on a piece of paper.
This process simulates the traditional way of practising spelling,
however, allowing students to do so in a self-service manner,
without the need to engage their teachers or parents.

## Features
- Adding and editing vocabularies for spelling
- View and play vocabularies in a spelling list before the real practice
- In real practice, play vocabularies one-by-one in randomized 
  or sequential order (configurable on the Settings page)
- Allow playing the same vocabulary for multiple times
- Support pronouncing English and Chinese vocabularies
- Showing the progress of practice
- Review played vocabularies
- Creating multiple spelling lists based on different dates or languages
- Swipe to delete a spelling list

## Data Access Layer
The project implements a data access layer 
with the Active Record pattern. 
It uses generics and inheritance 
to make the creation of data models easier.

## Dependencies
- sqflite
- flutter_tts
- shared_preferences

## Requirements
- Flutter 2.10.1 or higher
- Dart 2.16.1 or higher
