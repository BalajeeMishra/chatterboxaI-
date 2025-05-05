package com.talkyplay.zapai


import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity: FlutterActivity() {
    private lateinit var speechRecognizer: SpeechRecognizer
    private val CHANNEL = "speech_to_text"
    private val EVENT_CHANNEL = "speech_to_text_stream"
    private var eventSink: EventChannel.EventSink? = null
    private var isListening = false
    private var isUserStopped = false
    private val fullSpeechText = StringBuilder()
    private var lastRecognizedText = ""

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Method channel for commands
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startListening" -> {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                        == PackageManager.PERMISSION_GRANTED) {
                        startListening()
                        result.success(true)
                    } else {
                        ActivityCompat.requestPermissions(
                            this,
                            arrayOf(Manifest.permission.RECORD_AUDIO),
                            1
                        )
                        result.success(false)
                    }
                }
                "stopListening" -> {
                    stopListening()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Event channel for streaming text
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )

        // Initialize speech recognizer
        if (SpeechRecognizer.isRecognitionAvailable(this)) {
            speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this)
            setupRecognitionListener()
        }
    }

    private fun setupRecognitionListener() {
        speechRecognizer.setRecognitionListener(object : RecognitionListener {
            override fun onReadyForSpeech(params: Bundle?) {
                eventSink?.success(mapOf("status" to "listening", "text" to ""))
            }

            override fun onBeginningOfSpeech() {}

            override fun onRmsChanged(rmsdB: Float) {}

            override fun onBufferReceived(buffer: ByteArray?) {}

            override fun onEndOfSpeech() {

            }

            override fun onError(error: Int) {
                if (error != SpeechRecognizer.ERROR_CLIENT) { // Ignore client errors (from stop)
                    val errorMessage = when (error) {
                        SpeechRecognizer.ERROR_NETWORK_TIMEOUT -> "Network timeout"
                        SpeechRecognizer.ERROR_NETWORK -> "Network error"
                        SpeechRecognizer.ERROR_AUDIO -> "Audio error"
                        SpeechRecognizer.ERROR_SERVER -> "Server error"
                        SpeechRecognizer.ERROR_CLIENT -> "Client error"
                        SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> "No speech input"
                        SpeechRecognizer.ERROR_NO_MATCH -> "No match found"
                        SpeechRecognizer.ERROR_RECOGNIZER_BUSY -> "Recognizer is busy"
                        else -> "Unknown error occurred"
                    }
                    eventSink?.success(mapOf("status" to "error", "message" to errorMessage))
                }
                stopListening()
            }

            override fun onPartialResults(partialResults: Bundle?) {
                val matches = partialResults?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                if (!matches.isNullOrEmpty()) {
                    val latestText = matches.last().trim()

                    // ✅ Skip if latest is same or similar to last
                    if (isDuplicateOrSimilar(latestText, lastRecognizedText)) {
                        return
                    }

                    val newWords = latestText.removePrefix(lastRecognizedText).trim()

                    if (newWords.isNotEmpty()) {
                        fullSpeechText.append(" ").append(newWords)
                    }

                    lastRecognizedText = latestText
                    val finalText = fullSpeechText.toString().trim()
                    eventSink?.success(mapOf("status" to "recognizing", "text" to finalText))
                }
            }

            // ✅ Simple duplicate/similarity check
            private fun isDuplicateOrSimilar(current: String, previous: String): Boolean {
                // If it's exactly the same or current is a subset of previous
                if (current == previous || previous.contains(current)) {
                    return true
                }

                // Optional: if they're 90%+ similar (basic length-based similarity)
                val minLength = minOf(current.length, previous.length)
                val maxLength = maxOf(current.length, previous.length)
                if (minLength == 0) return false

                val similarity = minLength.toDouble() / maxLength
                return similarity > 0.9
            }


            override fun onResults(results: Bundle?) {}

            override fun onEvent(eventType: Int, params: Bundle?) {
                Log.d("SpeechRecognizer", "Event: $eventType")
            }
        })
    }

    private fun startListening() {
        if (!isListening) {
            fullSpeechText.clear()
            lastRecognizedText = ""
            isUserStopped = false
            isListening = true

            val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
                putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault())
                putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 1)
                putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
                putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_COMPLETE_SILENCE_LENGTH_MILLIS, 10000)
                putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_POSSIBLY_COMPLETE_SILENCE_LENGTH_MILLIS, 10000)
            }

            speechRecognizer.startListening(intent)
            eventSink?.success(mapOf("status" to "started"))
        }
    }

    private fun stopListening() {
        if (isListening) {
            isUserStopped = true
            speechRecognizer.stopListening()
            isListening = false

            val finalText = fullSpeechText.toString().trim()
            eventSink?.success(mapOf("status" to "stopped", "text" to finalText))
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::speechRecognizer.isInitialized) {
            speechRecognizer.destroy()
        }
    }
}








//package com.talkyplay.zapai
//import io.flutter.embedding.android.FlutterActivity
//
//
////import android.content.Context
////import android.media.AudioManager
////import io.flutter.embedding.android.FlutterActivity
////import io.flutter.plugin.common.MethodChannel
////import io.flutter.embedding.engine.FlutterEngine
//
//class MainActivity : FlutterActivity()
//
////{
////
////    private val CHANNEL = "volume_control"
////
////    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
////        super.configureFlutterEngine(flutterEngine)
////
////        // Setting up MethodChannel
////        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
////            when (call.method) {
////                "muteKeyboardSounds" -> {
////                    muteKeyboardSounds()
////                    result.success("Keyboard sounds muted")
////                }
////                else -> result.notImplemented()
////            }
////        }
////    }
////
////    // Function to mute system and keyboard sounds
////    private fun muteKeyboardSounds() {
////        try {
////            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
////
////            // Mute the system sound stream (includes touch sounds, keyboard typing, etc.)
////            audioManager.setStreamVolume(AudioManager.STREAM_SYSTEM, 0, AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE)
////
////            // Optionally mute accessibility sound stream (some devices play sound on voice typing)
////            audioManager.setStreamVolume(AudioManager.STREAM_ACCESSIBILITY, 0, AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE)
////
////            // Optionally mute notification sounds if necessary
////            audioManager.setStreamVolume(AudioManager.STREAM_NOTIFICATION, 0, AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE)
////
////            // Optionally mute ringtone sounds (if applicable)
////            audioManager.setStreamVolume(AudioManager.STREAM_RING, 0, AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE)
////
////        } catch (e: Exception) {
////            e.printStackTrace()
////        }
////    }
////}



