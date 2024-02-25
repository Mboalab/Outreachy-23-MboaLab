package io.flutter.plugins;
import java.io.File;
import java.util.ArrayList;
import be.tarsos.dsp.AudioDispatcher;
import be.tarsos.dsp.AudioEvent;
import be.tarsos.dsp.AudioProcessor;
import java.io.FileInputStream;
import be.tarsos.dsp.io.android.AudioDispatcherFactory;
import be.tarsos.dsp.mfcc.MFCC;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import be.tarsos.dsp.io.TarsosDSPAudioFormat;
import be.tarsos.dsp.io.UniversalAudioInputStream;
import be.tarsos.dsp.mfcc.MFCC;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.mfcc_flutter_project/audio";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getMFCC")) {
                                String filePath = call.argument("filePath");
                                // Use the new extractMFCC method
                                extractMFCC(filePath, result);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }
    private static final int TARGET_FRAMES = 130;
    private static final int COEFFICIENTS_PER_FRAME = 40;
    private void extractMFCC(String filePath, MethodChannel.Result flutterResult) {
        int sampleRate = 22050;
        int bufferSize = 1024;
        int bufferOverlap = 256;
        int numMelFilters = 40;
        int lowerFilterFreq = 0;
        int upperFilterFreq = sampleRate / 2;

        File audioFile = new File(filePath);
        AudioDispatcher dispatcher;

        try {
            TarsosDSPAudioFormat format = new TarsosDSPAudioFormat(TarsosDSPAudioFormat.Encoding.PCM_SIGNED, sampleRate, 16, 1, 2 * 1, sampleRate, false);
            UniversalAudioInputStream audioStream = new UniversalAudioInputStream(new FileInputStream(audioFile), format);
            dispatcher = new AudioDispatcher(audioStream, bufferSize, bufferOverlap);
        } catch (Exception e) {
            e.printStackTrace();
            flutterResult.error("ERROR", "Failed to create dispatcher: " + e.getMessage(), null);
            return;
        }

        MFCC mfcc = new MFCC(bufferSize, sampleRate, COEFFICIENTS_PER_FRAME, numMelFilters, 20, 600); // Adjusted for 40 coefficients
        dispatcher.addAudioProcessor(mfcc);

        final ArrayList<Double> mfccResults = new ArrayList<>();
        dispatcher.addAudioProcessor(new AudioProcessor() {
            @Override
            public boolean process(AudioEvent audioEvent) {
                float[] mfccOutput = mfcc.getMFCC();
                for (float v : mfccOutput) {
                    mfccResults.add((double) v);
                }
                return true;
            }

            @Override
            public void processingFinished() {
                // Ensure the results match the expected dimensions
            /*    int expectedSize = TARGET_FRAMES * COEFFICIENTS_PER_FRAME;
                while (mfccResults.size() < expectedSize) {
                    mfccResults.add(0.0); // Pad with zeros
                }

                // Optionally, trim the results if they exceed the expected size
                while (mfccResults.size() > expectedSize) {
                    mfccResults.remove(mfccResults.size() - 1);
                }*/

                flutterResult.success(mfccResults);
            }
        });

        new Thread(dispatcher, "Audio Dispatcher").start();
    }
}