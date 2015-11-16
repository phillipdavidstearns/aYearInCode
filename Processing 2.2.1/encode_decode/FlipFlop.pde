  class FlipFlop {  
    boolean state;
    boolean currentClock;
    boolean previousClock;

    FlipFlop() {
      state=false;
    }

    FlipFlop(boolean init) {
      state=init;
    }

    void flip(boolean clock) {
      currentClock = clock;
      if (!currentClock && previousClock) {
        state = !state;
      }
      previousClock = currentClock;
    }

    void reset() {
      state = false;
      currentClock = false;
      previousClock = false;
    }
  }
