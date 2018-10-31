float dist;//１フレーム前の座標との距離
float hand_x = 0, hand_y = 0, hand_z = 0;//手の座標
float out_of_cursol_x = 1000;//x軸のはみ出し許容範囲
float out_of_cursol_y = 800;//y軸のはみ出し許容範囲
float  hand_px, hand_py, hand_pz;//１フレーム前の手の座標
int slide_speed = 130;//スライドと見なす速さ
int slide_speed_mouse = 200;//マウスを使う場合のスライドと見なす速さ
float slide_degrees;//スライドした角度
float a_slide_degrees;//gsb本体の向き修正用の変数
int begin = 0;//はじめに出てしまうスライド判定の修正用変数
boolean slide;//スライドしているときtrueになる
boolean Pslide;//変数slideの１フレーム前の状態を保存
boolean hand_right, hand_left;//右手、または左手の場合trueになる
boolean hand_out = true;//手が画面外に出ているときにtrueになる
void leapOnConnect() 
{
  println("Leap Motion Connect");
}
void leepMotion() {

  for (Hand hand : leap.getHands ()) //インスタンスhandの数だけforを回す
  {
    hand_right = hand.isRight();
    hand_left = hand.isLeft();

    //１フレームの値を保存
    hand_px = hand_x;
    hand_py = hand_y;
    hand_pz = hand_z;

    //手の座標を代入
    hand_x = map(hand.getPosition().x, 300, 900, 0, width)-1000;
    hand_y = map(hand.getPosition().y, 300, 500, 0, height)-2000;   
    hand_z = hand.getPosition().z;
    if (hand_x < 0||hand_x > width||hand_y < 0||hand_y > height)
    {
      hand_out = true;
    } else {
      hand_out = false;
    }
    if (start_2%3 == 0)//同時出現を避けるため3フレームごとにdistを計測
    {
      dist = dist(hand_px, hand_py, hand_pz, hand_x, hand_y, hand_z);//１フレーム前の座標との距離を変数distに代入
    }
    Pslide = slide;//1フレーム前のslideの状態をPslideに格納
  }
  if (dist < - slide_speed||dist >  slide_speed) //スライドと見なす速度より手が早く動いたら
  {
    slide_degrees=  atan2(hand_y-hand_py, hand_x-hand_px);  //１フレーム前の座標を元にスライドした角度を取得し、変数slide_degreesに代入
    a_slide_degrees = -atan2(hand_x-hand_px, hand_y-hand_py);
    if (begin > 1)//２フレーム目までスライド判定をしない
    {
      slide =true;
    }
  } else {
    slide = false;
  }


  if (begin < 2)
  {

    begin ++;
  }
}



void mouse()//leepmotionの代わりにマウスを使用する場合の
{

  dist = dist(pmouseX, pmouseY, mouseX, mouseY);//１フレーム前の座標との距離を変数distに代入

  Pslide = slide;//1フレーム前のslideの状態をPslideに格納
  if (dist < - slide_speed_mouse||dist >  slide_speed_mouse) //スライドと見なす速度より手が早く動いたら
  {
    //slide_degrees = atan2(mouseY-pmouseY,mouseX-pmouseX);  //１フレーム前の座標を元にスライドした角度を取得し、変数slide_degreesに代入
    slide_degrees = atan2(mouseY-pmouseY, mouseX-pmouseX);  //１フレーム前の座標を元にスライドした角度を取得し、変数slide_degreesに代入
    a_slide_degrees = -atan2(mouseX-pmouseX, mouseY-pmouseY);
    if (begin > 1)//２フレーム目までスライド判定をしない
    {
      slide =true;
    }
  } else {
    slide = false;
  }
  //hand_cursor(mouseX, mouseY, 0);
  if (begin < 2)
  {
    begin ++;
  }
}

//カーソルを表示する関数
void hand_cursor(float x, float y, float z)
{
  noStroke();
  if (game_start == false&&set == 0)
  {
    textSize(12);
    textFont(font);
    fill(255);
    textAlign(CENTER);
    text("カーソル", x, y-30);
  }
  if (expiration==false&&soul_lose==false)
  {
    fill(232, 61, 110,200);
    ellipse(x, y, 32, 32);
  }
}

//スライド角度を可視化する関数
void check_degrees()
{
  if (slide == false&&Pslide == true)//スライド動作終了時のスライド角度を可視化
  {
    strokeWeight(5);
    stroke(0, 154, 214);
    line(width/2, height/2, cos(slide_degrees)*width+width/2, sin(slide_degrees)*height+height/2);
  }
}

void keyPressed()
{
  //W,A,S,Dキーを使ってソウルを操る処理（キーを押した時の処理）
  if (key == 'w')
  {
    up = true;
  }
  if (key == 's')
  {
    down = true;
  }
  if (key == 'd')
  {
    right = true;
  }
  if (key == 'a')
  {
    left = true;
  }

  if (keyCode == UP)
  {
    up = true;
  }
  if (keyCode == DOWN)
  {
    down = true;
  }
  if (keyCode == RIGHT)
  {
    right = true;
  }
  if (keyCode == LEFT)
  {
    left = true;
  }
  
  if ((keyCode == UP||key == 'w')&& set == 1)
  {
    MAX_HP +=1;
    select.play();
    select.rewind();
  }
  if ((keyCode == DOWN||key == 's')&&MAX_HP > 5&& set == 1)
  {
    MAX_HP -=1;
    select.play();
    select.rewind();
  }
  if ((keyCode == UP||key == 'w')&& set == 2)
  {
    ene_max += 10;
    select.play();
    select.rewind();
  }
  if (((keyCode == DOWN||key == 's')&& ene_max > 10)&& set == 2)
  {
    ene_max -= 10;
    select.play();
    select.rewind();
  }
}
//----------------------------------------------------------------------------------
void keyReleased() {
  //W,A,S,Dキーを使ってソウルを操る処理（キーを話した時の処理）
  if (key == 'w')
  {
    up = false;
  }
  if (key == 's')
  {
    down = false;
  }
  if (key == 'd')
  {
    right = false;
  }
  if (key == 'a')
  {
    left = false;
  }

  if (keyCode == UP)
  {
    up = false;
  }
  if (keyCode == DOWN)
  {
    down = false;
  }
  if (keyCode == RIGHT)
  {
    right = false;
  }
  if (keyCode == LEFT)
  {
    left = false;
  }
  if (keyCode == ENTER)
  { 
    if (set < 4&&game_start == false)//セッティング画面へ
    {
      set ++;
      retry.play();
      retry.rewind();
    }

    if (fin == true)
    {
      retry.play();
      retry.rewind();
      game_start = false;//タイトル画面に戻す
      ini();
    }
  }
}
