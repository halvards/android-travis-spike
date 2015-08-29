package com.skogsrud.halvard.androidtraviscispike;

import org.junit.Test;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.junit.Assert.assertThat;

/**
 * To work on unit tests, switch the Test Artifact in the Build Variants view.
 */
public class ExampleUnitTest {
    @Test
    public void additionIsCorrect() throws Exception {
        assertThat(2 + 2, equalTo(4));
    }
}