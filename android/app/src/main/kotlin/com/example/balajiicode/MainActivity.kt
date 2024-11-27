package com.talkyplay.zapai
import io.flutter.embedding.android.FlutterActivity


//import android.content.Context
//import android.media.AudioManager
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.plugin.common.MethodChannel
//import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity()

//{
//
//    private val CHANNEL = "volume_control"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        // Setting up MethodChannel
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//            when (call.method) {
//                "muteKeyboardSounds" -> {
//                    muteKeyboardSounds()
//                    result.success("Keyboard sounds muted")
//                }
//                else -> result.notImplemented()
//            }
//        }
//    }
//
//    // Function to mute system and keyboard sounds
//    private fun muteKeyboardSounds() {
//        try {
//            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
//
//            // Mute the system sound stream (includes touch sounds, keyboard typing, etc.)
//            audioManager.setStreamVolume(AudioManager.STREAM_SYSTEM, 0, AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE)
//
//            // Optionally mute accessibility sound stream (some devices play sound on voice typing)
//            audioManager.setStreamVolume(AudioManager.STREAM_ACCESSIBILITY, 0, AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE)
//
//            // Optionally mute notification sounds if necessary
//            audioManager.setStreamVolume(AudioManager.STREAM_NOTIFICATION, 0, AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE)
//
//            // Optionally mute ringtone sounds (if applicable)
//            audioManager.setStreamVolume(AudioManager.STREAM_RING, 0, AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE)
//
//        } catch (e: Exception) {
//            e.printStackTrace()
//        }
//    }
//}
