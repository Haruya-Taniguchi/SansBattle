int limit = 60;//制限時間
//タイトル画面の表示----------------------------------------------------------------------------------
PImage title;//タイトルの画像
float text_t = 0;
boolean game_start = false;
void title()
{
  tint(255, 255);
  image(title, width/2, height/2, width, height);
  textAlign(CENTER);
  textFont(font);
  text_t+=0.05;
  fill(255, map(sin(text_t), -1, 1, 0, 255));
  text("Please press enter key", width/2, 750);
}
//セッテイング画面の表示----------------------------------------------------------------------------------
int set = 0;
color c1 = color(255);
color c2 = color(255, 0, 0);
void setting()
{
  if (set > 0&&set < 4)
  {
    textSize(48);
    textAlign(CENTER);
  }
  switch(set)
  {
  case 1://hp設定
    textAlign(CENTER);
    textFont(font3);
    textSize(180);

    fill(c1);
    text(int(MAX_HP), width/4, 650);
    text(int(ene_max), width/1.5, 650);
    textFont(font3);
    textSize(90);

    fill(c1);
    text("HP", width/4, height/2.5);
    text("ENERGY", width/1.5, height/2.5);

    tuning();
    break;

  case 2://ene設定
    HP = MAX_HP;
    textAlign(CENTER);
    textFont(font3);
    textSize(180);
    fill(c2);
    text(int(MAX_HP), width/4, 650);
    fill(c1);
    text(int(ene_max), width/1.5, 650);

    textFont(font3);
    textSize(90);
    fill(c1);
    text("HP", width/4, height/2.5);
    text("ENERGY", width/1.5, height/2.5);

    tuning();
    break;

  case 3://ゲーム開始前
    ene = ene_max;
    textAlign(CENTER);
    textFont(font3);
    textSize(180);

    fill(c2);
    text(int(MAX_HP), width/4, 650);
    text(int(ene_max), width/1.5, 650);

    textFont(font3);
    textSize(90);
    fill(c1);
    text("HP", width/4, height/2.5);
    text("ENERGY", width/1.5, height/2.5);
    break;

  case 4:
    battle_start.play();//戦闘開始時のシステム音
    battle_start.rewind();
    game_start = true;
    break;
  }
}
int tuning_t1=255;
int tuning_t2=255;
void tuning() {
  int size = 24;
  println(mouseY);
  if(up){
    tuning_t1=128;
  }else{
    tuning_t1=255;
  }
   if(down){
    tuning_t2=128;
  }else{
    tuning_t2=255;
  }
  switch(set) {
  case 1:
    fill(255, tuning_t1);
    triangle(width/4-size*2, 480+size, width/4+size*2, 480+size, width/4, 480-size);
    fill(255, tuning_t2);
    triangle(width/4-size*2, 700-size, width/4+size*2, 700-size, width/4, 700+size);
    break;
  case 2:
    fill(255, tuning_t1);
    triangle(width/1.5-size*2, 480+size, width/1.5+size*2, 480+size, width/1.5, 480-size);
    fill(255, tuning_t2);
    triangle(width/1.5-size*2, 700-size, width/1.5+size*2, 700-size, width/1.5, 700+size);
    break;
  }
}
//1P,2Pの確認用表示----------------------------------------------------------------------------------
void player()
{
  if (start_2 < 180)
  {
    textSize(12);
    textFont(font2);
    fill(255, 0, 0);
    textAlign(CENTER);
    text("↓1P", width/2, 80);

    textSize(12);
    textFont(font2);
    fill(0, 0, 255);
    textAlign(CENTER);
    text("↓2P", soul.x, soul.y-30);
  }
}
//制限時間----------------------------------------------------------------------------------
int time;
int r_time;//のこり時間（秒）
int expiration_time = 0;//時間切れになってから経過したフレーム数
boolean crisis = false;//残り時間わずかになるとtrueになる
boolean expiration = false;

void time_limit()
{
  textFont(font2, 24);
  r_time=limit-start_2/60;
  if (expiration == false)
  {
    fill(255);
    textAlign(CORNER);
    text("time limit      "+"s", 50, 50);
    if (crisis == false)
    {
      fill(255, 0, 0);
    } else {
      if (start_2%3 == 0)
      {
        fill(255, 255, 0);
      } else {
        fill(255, 0, 0);
      }
    }
    textSize(48);
    textAlign(CENTER);
    text(r_time, 358, 50);
    textAlign(CORNER);
    if (r_time < 11)
    {
      crisis = true;
    }
    if (crisis == true&&start%60 == 0)
    {
      retry.play();
      retry.rewind();
    }
  }
  if (start_2/60 >= limit)
  {
    expiration = true;
  }
}
//枠を表示する関数----------------------------------------------------------------------------------
float frameWeight;//枠の太さ
float frame_x_1;//枠の右上の頂点のx座標
float  frame_y_1;//枠の右上の頂点のy座標
float frame_width_1;//枠の幅
float frame_height_1;//枠の高さ
float frame_center_x;//枠の中心のx座標
float frame_center_y;//枠の中心のy座標
void frame()
{
  stroke(255);
  fill(0, 0);
  strokeWeight(frameWeight);
  rect(frame_x_1+vx, frame_y_1+vy, frame_width_1, frame_height_1);
}
void display()//hpなどを表示
{
  fill(255);
  textFont(font2, 48);
  textSize(30); 
  textAlign(CORNER);
  text("Frisk  LV.19   HP", 250+vx, 870+vy);
  text("HP"+int(HP)+"/"+int(MAX_HP), 1050+vx, 870+vy);
  println(mouseY);
  noStroke();
  fill(255, 0, 0);
  rect(765+vx, 830+vy, 245, 55);
  if (soul_lose == false)
  {
    fill(255, 255, 0);
    if (HP == 0)
    {
      rect(765+vx, 830+vy, 0, 55);
    } else {
      rect(765+vx, 830+vy, map(HP, 0, MAX_HP, 0, 245), 55);
    }
  }
}
//ゲーム終了時の画面表示----------------------------------------------------------------------------------
PImage player_1_win;//ゲーム終了時の画像１
PImage player_2_win;//ゲーム終了時の画像２
float fin_t = 0;
float fin_text_t = 0;
boolean fin = false;
void fin(int result)
{
  if (result == 1)
  {
    fin = true;
    fin_t+=5;
    imageMode(CENTER);
    tint(255, fin_t);
    image(player_1_win, width/2, height/2);
    //文字
    textFont(font);
    fin_text_t+=0.05;
    fill(255, map(sin(fin_text_t), -1, 1, 0, 255));
    textAlign(CENTER);
    textSize(30);
    text("Please press enter key", width/2, height/1.2);
  } else
    if (result == 2)
    {
      fin = true;
      fin_t+=5;
      imageMode(CENTER);
      tint(255, fin_t);
      image(player_2_win, width/2, height/2);
      //文字
      textFont(font);
      fin_text_t+=0.05;
      fill(255, map(sin(fin_text_t), -1, 1, 0, 255));
      textAlign(CENTER);
      textSize(30);
      text("Please press enter key", width/2, 875);
    }
}
//gasterbrasterで攻撃するのに必要なenergyの管理----------------------------------------------------------------------------------
float ene_max = 100;//energyの最大値
float ene_chage = 0.35;//1フレームあたりのenergyの回復量
float ene;//gsbを出現させるたびに消費される
boolean chage = false;//energyのチャージ中trueになる
void ene()//eneの管理をする
{
  textAlign(CENTER);
  if (chage == false)
  {
    fill(255);
    text("Energy", 225+vx, 350+vy);
  } else {
    fill(255, 0, 0);
    text("Chaging...", 225+vx, 350+vy);
  }
  textAlign(LEFT);
  if (ene < 0)
  {
    chage = true;
    ene = 0;
  }
  if (ene < ene_max&&chage == false)//通常リロード
  {
    ene += ene_chage*(ene_max/100);
  } else
    if (chage == true&& ene == ene_max)
    {
      chage = false;
    }
  if (ene < ene_max&&chage == true)//オーバーヒート時リロード
  {
    ene+=ene_chage*(ene_max/100);
  } else
    if (ene > ene_max-50&&chage == true)
    {
      chage = false;
    }
  if (chage == true)
  {
    fill(255, 0, 0);
  } else {
    fill(255, map(ene, 0, ene_max, 50, 255), 0);
  }
  noStroke();
  rect(200+vx, 420+vy, 56, map(ene, 0, ene_max, 0, 300)); 
}
