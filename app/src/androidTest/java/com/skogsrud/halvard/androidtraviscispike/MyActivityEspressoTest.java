package com.skogsrud.halvard.androidtraviscispike;

import android.support.test.rule.ActivityTestRule;
import android.test.suitebuilder.annotation.LargeTest;

import org.junit.Rule;
import org.junit.Test;

import static android.support.test.espresso.Espresso.onView;
import static android.support.test.espresso.assertion.ViewAssertions.matches;
import static android.support.test.espresso.matcher.ViewMatchers.withId;
import static android.support.test.espresso.matcher.ViewMatchers.withText;

@LargeTest
public class MyActivityEspressoTest {
    @Rule
    public ActivityTestRule<MyActivity> activityTestRule = new ActivityTestRule<>(MyActivity.class);

    @Test
    public void testMyActivityShouldSayHelloWorld() throws Exception {
        onView(withId(R.id.text)).check(matches(withText("Hello Espresso!")));
    }
}
