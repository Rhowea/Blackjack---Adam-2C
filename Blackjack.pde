//for en gangs skyld ville jeg ønske, jeg havde prokrastineret, så jeg vidste noget om objects, før jeg lavede størstedelen af det her :(
String[] Deck = new String[52]; //The deck of cards
int CardValue = 1;
String Suit = " of Spades";
int HandSize; //Player's hand size
int DHandSize; //Dealer's hand size
String[] Hand = new String[7];
String[] DHand = new String[7];
int[] HandValue = new int[7];
int[] DHandValue = new int[7];
int totalValue;
int DTotalValue;
boolean BJ = false;
boolean DBJ = false;
boolean PStand = false;
boolean openingHand = true;
boolean gameEnd = false;

void setup() {
  size(500, 500);
  for (int DeckNumber=0; DeckNumber<52; DeckNumber++) {
    if (CardValue == 1) {
      Deck[DeckNumber] = "Ace" + Suit;
    } else if (CardValue == 11) {
      Deck[DeckNumber] = "Jack" + Suit;
    } else if (CardValue == 12) {
      Deck[DeckNumber] = "Queen" + Suit;
    } else if (CardValue == 13) {
      Deck[DeckNumber] = "King" + Suit;
    } else {
      Deck[DeckNumber] = CardValue + Suit;
    }
    CardValue = CardValue + 1;
    if (CardValue == 14) {
      CardValue = 1;
      if (Suit.equals(" of Spades")) {
        Suit = " of Hearts";
      } else {
        if (Suit.equals(" of Hearts")) {
          Suit = " of Clubs";
        } else {
          if (Suit.equals(" of Clubs")) {
            Suit = " of Diamonds";
          }
        }
      }
    }
  }
  DrawOpeningHand();
  DrawDealerOpeningHand();
  redraw();
}

void draw() {
  clear();
  background(100);
  if (openingHand == true) {
    ValueHand();
    DValueHand();
    openingHand = false;
  }
  rectMode(CENTER);
  textSize(20);
  textAlign(CENTER);
  text("Hit", 100, 300);
  rect(100, 350, 80, 80);
  text("Stand", 400, 300);
  rect(400, 350, 80, 80);
  text("Your hand", 100, 50);
  text(totalValue, 100, 100);
  text("Dealer's hand", 400, 50);
  text(DTotalValue, 400, 100);
  
  for(int i = 0; i < HandSize; i++){
    text(Hand[i], 100, 25*i+150);
  }
  for(int i = 0; i < DHandSize; i++){
    text(DHand[i], 400, 25*i+150);
  }

  if (totalValue > 21) {
    text("You bust!", 250, 250);
    text("Dealer wins", 250, 300);
  }
  if (totalValue == 21) {
    text("It's a blackjack", 250, 250);
    text("You win", 250, 300);
  }

  if (PStand == true) {
    if (DTotalValue < totalValue) {
      text("You have more", 250, 250);
      text("You win!", 250, 300);
    } else if (totalValue < DTotalValue && DTotalValue < 21) {
      text("Dealer has more", 250, 250);
      text("Dealer wins", 250, 300);
    } else if (DTotalValue > 21) {
      text("Dealer has bust", 250, 250);
      text("you win!", 250, 300);
    }else if(DTotalValue == totalValue){
      text("You have equal hands", 250, 250);
      text("Push", 250, 300);
    }
  }
}

void mouseClicked() {

  if (mouseX >= 60 && mouseX <= 140 && mouseY >= 310 && mouseY <= 390 && gameEnd == false) {
    DrawCard();
  }
  if (mouseX >= 360 && mouseX <= 440 && mouseY >= 310 && mouseY <=390 && gameEnd == false) {
    PlayerStand();
  }
}

void DrawOpeningHand() {
  HandSize = 2;
  for (int CardsInHand = 0; CardsInHand < HandSize; CardsInHand++) {
    Hand[CardsInHand] = Deck[int(random(0, 51))];
  }
  while (Hand[0].equals(Hand[1])) {
    Hand[1] = Deck[int(random(0, 53))];
  }
  println("Your hand:");
  for (int x = 0; x < HandSize; x++) {
    println(Hand[x]);
  }
}

void DrawDealerOpeningHand() {
  DHandSize = 2;
  for (int CardsInHand = 0; CardsInHand < DHandSize; CardsInHand++) {
    DHand[CardsInHand] = Deck[int(random(0, 51))];
  }
  for (int x = 0; x < 2; x++) {
    for (int y = 0; x < 2; x++) {
      while (DHand[x].equals(Hand[y])||DHand[0].equals(DHand[1])) {
        DHand[x] = Deck[int(random(0, 52))];
      }
    }
  }
  println("-------------------");
  println("Dealer's hand:");
  for (int x = 0; x < DHandSize; x++) {
    println(DHand[x]);
  }
}

void DValueHand() {
  redraw();
  DTotalValue = 0;
  for (int x = 0; x < DHandSize; x++) {
    DHandValue[x] = SplitCard(DHand[x]);
  }
  for (int x = 0; x < DHandSize; x++) {
    DTotalValue = DTotalValue + DHandValue[x];
  }
  if (DTotalValue > 21) {
    for (int x = 0; x < DHandSize; x++) {
      if (DHandValue[x] == 11) {
        DHandValue[x] = 1;
        DTotalValue = 0;
        for (int y = 0; y < DHandSize; y++) {
          DTotalValue = DTotalValue + DHandValue[y];
        }
      }
    }
  }
  redraw();
  println("Dealer has: " + DTotalValue);
  if (DTotalValue == 21) {
    DBJ = true;
    println("-------------------");
    println("Blasted! Dealer has Blackjack!");
    ;
    CheckScores();
  }
  if (DTotalValue > 21) {
    println("-------------------");
    println("Dealer has gone bust!");
    ;
    CheckScores();
  }
  if (PStand == true) {
    if (DTotalValue < totalValue && DTotalValue < 16 || DTotalValue == 16) {
      DealerDraw();
    } else {
      DealerStand();
    }
    if (DTotalValue == 17) {
      println("-------------------");
      println("Dealer stands on 17");
      CheckScores();
    }
  }
  if (PStand == true) {
    CheckScores();
  }
}

void CheckScores() {
  gameEnd = true;
  if (BJ == true) {
    redraw();
    println("-------------------");
    println("You win!");
  } else if (DBJ == true) {
    redraw();
    println("-------------------");
    println("Dealer wins");
  } else if (totalValue > 21) {
    println("-------------------");
    println("Dealer wins");
  } else if (DTotalValue > 21) {
    println("-------------------");
    println("You win!");
  } else if (DTotalValue > totalValue) {
    println("-------------------");
    println("Dealer wins");
  } else if (DTotalValue < totalValue) {
    println("-------------------");
    println("You win!");
  }
}

void DrawCard() {
  println("-------------------");
  println("You hit!");
  HandSize++;
  Hand[HandSize - 1] = Deck[int(random(0, 51))];
  for (int OtherCards = HandSize - 1; OtherCards < HandSize; OtherCards++) {
    if (Hand[OtherCards].equals(Hand[HandSize - 2])||Hand[OtherCards].equals(DHand[HandSize - 1])) {
      Hand[HandSize] = Deck[int(random(0, 51))];
    }
  }
  println("Your hand:");
  for (int x = 0; x < HandSize; x++) {
    println(Hand[x]);
  }
  ValueHand();
}

void ValueHand() {
  redraw();
  totalValue = 0;
  for (int x = 0; x < HandSize; x++) {
    HandValue[x] = SplitCard(Hand[x]);
  }
  for (int x = 0; x < HandSize; x++) {
    totalValue = totalValue + HandValue[x];
  }
  if (totalValue > 21) {
    for (int x = 0; x < HandSize; x++) {
      if (HandValue[x] == 11) {
        HandValue[x] = 1;
        totalValue = 0;
        for (int y = 0; y < HandSize; y++) {
          totalValue = totalValue + HandValue[y];
        }
      }
    }
  }
  redraw();
  println("You have: " + totalValue);
  if (totalValue == 21) {
    println("-------------------");
    println("Congratulations! It's a Blackjack!");
    BJ = true;

    CheckScores();
  }
  if (totalValue > 21) {
    println("-------------------");
    println("Blasted! You've gone bust!");
    CheckScores();
  }
}

int SplitCard(String x) {
  String[] Split = split(x, ' ');
  int Value = parseInt(Split[0]);
  if (Split[0].equals("King")||Split[0].equals("Queen")||Split[0].equals("Jack")) {
    Value = 10;
  }
  if (Split[0].equals("Ace")) {
    Value = 11;
  }
  return Value;
}

void PlayerStand() {
  PStand = true;
  println("-------------------");
  println("You Stand");
  if (DTotalValue < 16) {
    if (totalValue > DTotalValue) {
      DealerDraw();
    } else {
      DealerStand();
    }
  }
  if (DTotalValue == 16) {
    DealerDraw();
  }
}

void DealerDraw() {
  println("-------------------");
  println("Dealer hit!");
  DHandSize++;
  DHand[DHandSize - 1] = Deck[int(random(0, 51))];
  for (int OtherCards = DHandSize - 1; OtherCards < DHandSize; OtherCards++) {
    if (DHand[OtherCards].equals(DHand[HandSize - 2])||DHand[OtherCards].equals(Hand[HandSize - 1])) {
      DHand[DHandSize] = Deck[int(random(0, 51))];
    }
  }
  println("Dealer's hand:");
  for (int x = 0; x < DHandSize; x++) {
    println(DHand[x]);
  }
  DValueHand();
}

void DealerStand() {
  PStand = true;
  println("-------------------");
  println("Dealer Stands");
  CheckScores();
}
