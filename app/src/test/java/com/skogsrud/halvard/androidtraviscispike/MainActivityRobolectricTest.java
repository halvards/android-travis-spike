package com.skogsrud.halvard.androidtraviscispike;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricGradleTestRunner;
import org.robolectric.annotation.Config;

import static org.hamcrest.CoreMatchers.notNullValue;
import static org.junit.Assert.assertThat;

@RunWith(RobolectricGradleTestRunner.class)
@Config(constants = BuildConfig.class, sdk = 21)
public class MainActivityRobolectricTest {
    @Test
    public void testRobolectric() throws Exception {
        assertThat(Robolectric.setupActivity(MainActivity.class), notNullValue());
    }
}
