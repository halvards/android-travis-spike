package com.skogsrud.halvard.androidtraviscispike;

import android.os.IBinder;

import org.junit.rules.TestRule;
import org.junit.runner.Description;
import org.junit.runners.model.Statement;

import java.lang.reflect.Method;
import java.util.Arrays;

/**
 * Adapted from http://product.reverb.com/2015/06/06/disabling-animations-in-espresso-for-android-testing/
 */
public class DisableAnimationsRule implements TestRule {
    private Method getAnimationScalesMethod;
    private Method setAnimationScalesMethod;
    private Object windowManagerObject;

    public DisableAnimationsRule() {
        try {
            Class<?> windowManagerStubClazz = Class.forName("android.view.IWindowManager$Stub");
            Method asInterface = windowManagerStubClazz.getDeclaredMethod("asInterface", IBinder.class);

            Class<?> serviceManagerClazz = Class.forName("android.os.ServiceManager");
            Method getService = serviceManagerClazz.getDeclaredMethod("getService", String.class);

            Class<?> windowManagerClazz = Class.forName("android.view.IWindowManager");

            setAnimationScalesMethod = windowManagerClazz.getDeclaredMethod("setAnimationScales", float[].class);
            getAnimationScalesMethod = windowManagerClazz.getDeclaredMethod("getAnimationScales");

            IBinder windowManagerBinder = (IBinder) getService.invoke(null, "window");
            windowManagerObject = asInterface.invoke(null, windowManagerBinder);
        } catch (Exception e) {
            throw new RuntimeException("Failed to access animation methods", e);
        }
    }

    @Override
    public Statement apply(final Statement statement, Description description) {
        return new Statement() {
            @Override
            public void evaluate() throws Throwable {
                setAnimationScaleFactors(0.0f);
                try {
                    statement.evaluate();
                } finally {
                    setAnimationScaleFactors(1.0f);
                }
            }
        };
    }

    private void setAnimationScaleFactors(float scaleFactor) throws Exception {
        float[] scaleFactors = (float[]) getAnimationScalesMethod.invoke(windowManagerObject);
        Arrays.fill(scaleFactors, scaleFactor);
        setAnimationScalesMethod.invoke(windowManagerObject, scaleFactors);
    }
}
