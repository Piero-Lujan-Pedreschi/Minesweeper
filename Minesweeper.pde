import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_MINES = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
void setup() {
  size(400, 400);
  textAlign(CENTER, CENTER);
  
  //make manager
  Interactive.make( this );
  
  //you rcode to initiate buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  setMines();
}

public void setMines()
{
  while(mines.size() < NUM_MINES) 
  {
    int r = (int)(Math.random() *  NUM_ROWS);
    int c = (int)(Math.random() *  NUM_COLS);
    if(mines.contains(buttons[r][c]) == false)
    {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
       displayWinningMessage();
    else if(isWon() == false)
      displayLosingMessage();
}
public boolean isWon()
{
    for(int r = 0; r < buttons.length; r++) {
      for(int c = 0; c < buttons[r].length; c++) {
        if(!mines.contains(buttons[r][c]) && buttons[r][c].isClicked() == false)
          return false;
      }
    }
    return true;
 }
public void displayLosingMessage()
{
    for(int i = 0; i < mines.size(); i++) {
      if(mines.get(i).isClicked()==false)
        mines.get(i).mousePressed();
    }
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][10].setLabel("L");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("S");
    buttons[10][13].setLabel("E");
}
public void displayWinningMessage()
{
    buttons[10][7].setLabel("Y");
    buttons[10][8].setLabel("O");
    buttons[10][9].setLabel("U");
    buttons[10][11].setLabel("W");
    buttons[10][12].setLabel("I");
    buttons[10][13].setLabel("N");
}
public boolean isValid(int r, int c)
{
  if(r <NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0)
    return true;
  return false;
}
public int countMines(int row, int col)
{
   int [][] posMods = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};
   int numMines = 0;
     for(int i = 0; i < posMods.length; i++) {
       int newRow = row + posMods[i][0];
       int newCol = col + posMods[i][1];
       if(isValid(newRow, newCol) == false)
         continue;
         //check id button is already clicked
       if(mines.contains(buttons[newRow][newCol]) == true)
         numMines++;
      }
    return numMines;  
}

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public boolean isClicked() 
    {
      return clicked;
    }
    public void mousePressed () 
    {
      clicked = true;
      if(mouseButton == RIGHT) {
        flagged = !flagged;
        clicked = flagged;
      } else if(mines.contains(this)) {
        displayLosingMessage();
      } else if(countMines(myRow, myCol) > 0) {
        setLabel(countMines(myRow, myCol));
      } else {
        int [][] posMods1 = {{-1, 0}, {0, -1}, {0, 1}, {1, 0}};
        for(int i = 0; i < posMods1.length; i++) {    
          int newRow = myRow + posMods1[i][0];
          int newCol = myCol + posMods1[i][1];
          buttons[newRow][newCol].mousePressed();
        }
      }
    }
    
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
