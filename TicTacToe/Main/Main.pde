String[][] board = {
  {"", "", ""},
  {"", "", ""},
  {"", "", ""}
};

String[] players = {"X", "O"};

int wins1 = 0, wins2 = 0;

String currentPlayer;
void setup() {
  size(400, 400);
  restartGame();
}

void mousePressed() {
  if(mouseButton == LEFT) {
    if(mouseX <= width / 3 && mouseY <= height / 3) {
      tryswitchTurn(setBoard(0, 0));
    } else if(mouseX <= width - width / 3 && mouseY <= height / 3) {
      tryswitchTurn(setBoard(1, 0));
    } else if(mouseX <= width && mouseY <= height / 3) {
      tryswitchTurn(setBoard(2, 0));
    } else if(mouseX <= width / 3 && mouseY <= height - height / 3) {
      tryswitchTurn(setBoard(0, 1));
    } else if(mouseX <= width - width / 3 && mouseY <= height - height / 3) {
      tryswitchTurn(setBoard(1, 1));
    } else if(mouseX <= width && mouseY <= height - height / 3) {
      tryswitchTurn(setBoard(2, 1));
    } else if(mouseX <= width / 3 && mouseY <= height) {
      tryswitchTurn(setBoard(0, 2));
    } else if(mouseX <= width - width / 3 && mouseY <= height) {
      tryswitchTurn(setBoard(1, 2));
    } else if(mouseX <= width && mouseY <= height) {
      tryswitchTurn(setBoard(2, 2));
    }
  }
}

void keyPressed() {
  if(key == 'r') {
    restartGame();
  } else if(key == '1') { 
    wins1++;
  } else if(key == '2') {
    wins2++;
  }
}

void restartGame() {
  if(random(1) < 0.5) { 
    currentPlayer = players[0];
  } else {
    currentPlayer = players[1];
  }
  
  board = new String[][] {
    {"", "", ""},
    {"", "", ""},
    {"", "", ""}
  };
}

void tryswitchTurn(boolean doit) {
  if(doit) {
    switch(currentPlayer) {
      case "X":
        currentPlayer = "O";
        break;
      case "O":
        currentPlayer = "X";
        break;
    }
  }
}

boolean setBoard(int indX, int indY) {
  if(board[indX][indY].equals("")) {
    if(currentPlayer.equals(players[0])) {
      board[indX][indY] = "X";
    } else if(currentPlayer.equals(players[1])) {
      board[indX][indY] = "O";
    }
    return true;
  } else {
    return false;
  }
}

void draw() {
  background(100);
  fill(0);
  if(currentPlayer.equals(players[0])) {
    text("1", 15, 15);
  } else if(currentPlayer.equals(players[1])) {
    text("2", 15, 15);
  }
  
  text(wins1, width / 2 - 50, 15);
  text(wins2, width / 2 + 45, 15);
  
  var w = width / 3;
  var h = height / 3;
  
  line(w, 0, w, height); // Draw the grid!
  line(w * 2, 0, w * 2, height);
  line(0, h, width, h);
  line(0, h * 2, width, h * 2);
  
  for(var j = 0; j < 3; j++) {
    for(var i = 0; i < 3; i++) {
      var x = w * i + w / 2;
      var y = h * j + h / 2;
      var spot = board[i][j];
      if(spot.equals(players[1])) {
        noFill();
        ellipse(x, y, w / 2, w / 2);
      } else if(spot.equals(players[0])) {
        var xs = w / 4;
        
        line(x - xs, y - xs, x + xs, y + xs);
        line(x + xs, y - xs, x - xs, y + xs );
      }
    }
  }
}
