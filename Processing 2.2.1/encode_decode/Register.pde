class Register {

  boolean[] data;

  Register(int _length) {
    data = new boolean[_length];
    for (int i = 0; i < data.length; i++) {
      if (i == 0) { 
        data[0] = true ;
      } else {
        data[i] = false;
      }
    }
  }

  void load(boolean[] _input) {
    for (int i = 0; i < data.length; i++) {
      data[i] = _input[i];
    }
  }

  void load(int _index, boolean _input) {
    data[_index] = _input;
  }

  void shiftLeft(boolean _input) {
    for (int i = data.length-1; i > 0; i--) {
      data[i] = data[i-1];
    }
    data[0] = _input;
  }

  void shiftLeft() {
    for (int i = data.length-1; i > 0; i--) {
      data[i] = data[i-1];
    }
    data[0] = false;
  }

  void shiftRight(boolean _input) {
    for (int i = 0; i < data.length-1; i++) {
      data[i] = data[i+1];
    }
    data[data.length-1] = _input;
  }

  void shiftRight() {
    for (int i = 0; i < data.length-1; i++) {
      data[i] = data[i+1];
    }
    data[data.length-1] = false;
  }

  void reset() {
    for (int i = 0; i < data.length; i++) {
      data[i] = false;
    }
  }

  void randomize() {
    for (int i = 0; i < data.length; i++) {
      if (random(1) < random(1)) {
        data[i]=true;
      } else {
        data[i]=false;
      }
    }
  }

  String states() {
    String _states = new String();
    for (int i = data.length-1; i >= 0; i--) {
      _states += int(data[i]);
    }
    return _states;
  }

  int value() {
    int _value = 0;
    for (int i = 0; i < data.length; i++) {
      _value += int(data[i]) << i;
    }
    return _value;
  }

  void reverse() {
    boolean[] buffer = new boolean[data.length];
    for (int i = 0; i < data.length; i++) {
      buffer[i] = data[i];
    }
    for (int i = 0; i < data.length; i++) {
      data[i] = buffer[data.length - 1 - i];
    }
  }

  void invert() {
    for (int i = 0; i < data.length; i++) {
      data[i] = !data[i];
    }
  }

  void increment() {
    Counter _buffer = new Counter(data.length, data);
    _buffer.increment();
    for (int i = 0; i < data.length; i++) {
      data[i] = _buffer.register[i].state;
    }
  }

  void decrement() {
    Counter _buffer = new Counter(data.length, data);
    _buffer.decrement();
    for (int i = 0; i < data.length; i++) {
      data[i] = _buffer.register[i].state;
    }
  }
}

