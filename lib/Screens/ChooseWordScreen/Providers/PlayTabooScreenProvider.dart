import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayTabooScreenProvider extends ChangeNotifier {
  // Speech related states
  bool _startListening = false;
  bool _speechEnabled = false;
  String _lastWords = '';
  String _previousWords = '';
  String _ques = "";
  bool _isLoading = false;
  bool _apiCalled = false;
  bool _isFirstTime = false;
  bool _isLoaderShow = false;
  bool _isMuted = false;
  String _currentSpeechText = "";
  bool _isOnLockedAndRestartListening = false;
  bool _isRecongningText = false;

  // Screen2 data
  double _speechRate = 0.3;
  bool _isSpeaking = false;
  String _message = '';
  int _lastSpokenIndex = 0;
  String _selectedLanguage = 'English';
  bool _isSpeechInitialized = false;
  bool _isPopAvailable = false;

  // UI states
  bool _isExpanded = false;
  bool _isLocked = false;
  bool _isshowHistoryAndSubtitle = true;
  bool _isSwipingLeft = false;
  bool _isSwipingUp = false;
  bool _isKeyBoardOpen = false;
  bool _isOnPressedEnd = false;
  String _previousSpokenTextWhenStateIsLocked ='' ;
  bool _isTtsComplete = false;

  //controller


  // Getters
  bool get startListening => _startListening;
  bool get speechEnabled => _speechEnabled;
  String get lastWords => _lastWords;
  String get previousWords => _previousWords;
  String get ques => _ques;
  bool get isLoading => _isLoading;
  bool get apiCalled => _apiCalled;
  bool get isFirstTime => _isFirstTime;
  bool get isLoaderShow => _isLoaderShow;
  bool get isMuted => _isMuted;
  String get currentSpeechText => _currentSpeechText;
  double get speechRate => _speechRate;
  bool get isSpeaking => _isSpeaking;
  String get message => _message;
  int get lastSpokenIndex => _lastSpokenIndex;
  String get selectedLanguage => _selectedLanguage;
  bool get isSpeechInitialized => _isSpeechInitialized;
  bool get isPopAvailable => _isPopAvailable;
  bool get isExpanded => _isExpanded;
  bool get isLocked => _isLocked;
  bool get isshowHistoryAndSubtitle => _isshowHistoryAndSubtitle;
  bool get isSwipingLeft => _isSwipingLeft;
  bool get isSwipingUp => _isSwipingUp;
  bool get isKeyBoardOpen => _isKeyBoardOpen;
  bool get isOnPressedEnd => _isOnPressedEnd;
  bool get isOnLockedAndRestartListening => _isOnLockedAndRestartListening;
  bool get isRecognizingText => _isRecongningText;
  String get previousSpokenTextWhenStateIsLocked => _previousSpokenTextWhenStateIsLocked;
  bool get isTtsCompleted => _isTtsComplete;

  // Setters
  void setpreviousSpokenTextWhenStateIsLocked(String val){
    _previousSpokenTextWhenStateIsLocked = val;
    notifyListeners();
  }
  void setStartListening(bool value) {
    _startListening = value;
    notifyListeners();
  }
  void setIsRecognizingText(bool value){
    _isRecongningText =value;
    notifyListeners();
  }

  void setSpeechEnabled(bool value) {
    _speechEnabled = value;
    notifyListeners();
  }

  void setLastWords(String value) {
    _lastWords = value;
    notifyListeners();
  }

  void setPreviousWords(String value) {
    _previousWords = value;
    notifyListeners();
  }

  void setQues(String value) {
    _ques = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setApiCalled(bool value) {
    _apiCalled = value;
    notifyListeners();
  }

  void setIsFirstTime(bool value) {
    _isFirstTime = value;
    notifyListeners();
  }

  void setIsLoaderShow(bool value) {
    _isLoaderShow = value;
    notifyListeners();
  }

  void setIsMuted(bool value) {
    _isMuted = value;
    notifyListeners();
  }

  void setCurrentSpeechText(String value) {
    _currentSpeechText = value;
    notifyListeners();
  }

  void setSpeechRate(double value) {
    _speechRate = value;
    notifyListeners();
  }

  void setIsSpeaking(bool value) {
    _isSpeaking = value;
    notifyListeners();
  }

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  void setLastSpokenIndex(int value) {
    _lastSpokenIndex = value;
    notifyListeners();
  }

  void setSelectedLanguage(String value) {
    _selectedLanguage = value;
    notifyListeners();
  }

  void setIsSpeechInitialized(bool value) {
    _isSpeechInitialized = value;
    notifyListeners();
  }

  void setIsPopAvailable(bool value) {
    _isPopAvailable = value;
    notifyListeners();
  }

  void setIsExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }

  void setIsLocked(bool value) {
    _isLocked = value;
    notifyListeners();
  }

  void setIsshowHistoryAndSubtitle(bool value) {
    _isshowHistoryAndSubtitle = value;
    notifyListeners();
  }

  void setIsSwipingLeft(bool value) {
    _isSwipingLeft = value;
    notifyListeners();
  }

  void setIsSwipingUp(bool value) {
    _isSwipingUp = value;
    notifyListeners();
  }

  void setIsKeyBoardOpen(bool value) {
    _isKeyBoardOpen = value;
    notifyListeners();
  }

  void setIsOnPressedEnd(bool value) {
    _isOnPressedEnd = value;
    notifyListeners();
  }
  void setIsOnLockedAndRestartListening(bool value) {
    _isOnLockedAndRestartListening = value;
    notifyListeners();
  }
  void setIsTtsCompleted(bool val){
    _isTtsComplete = val;
  }
  // void setIsAllTextProcessedByCloud(bool val){
  //   _isAlltextProccessedByCloud = val;
  // }

  // Reset all states
  void resetAllStates() {
    _startListening = false;
    _speechEnabled = false;
    _lastWords = '';
    _previousWords = '';
    _ques = "";
    _isLoading = false;
    _apiCalled = false;
    _isFirstTime = false;
    _isLoaderShow = false;
    _isMuted = false;
    _currentSpeechText = "";
    _speechRate = 0.3;
    _isSpeaking = false;
    _message = '';
    _lastSpokenIndex = 0;
    _selectedLanguage = 'English';
    _isSpeechInitialized = false;
    _isPopAvailable = false;
    _isExpanded = false;
    _isLocked = false;
    _isshowHistoryAndSubtitle = true;
    _isSwipingLeft = false;
    _isSwipingUp = false;
    _isKeyBoardOpen = false;
    _isOnPressedEnd = true;
    _isOnLockedAndRestartListening = false;
    _isRecongningText = false;
    _previousSpokenTextWhenStateIsLocked = '';
    _isTtsComplete = false;
    notifyListeners();
  }
} 