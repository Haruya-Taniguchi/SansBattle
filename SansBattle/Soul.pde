PImage player_soul;//プレイヤーのソウルの画像の変数を宣言
PImage soul_dead;//やられ時のソウルの画像
boolean up=false, down=false, right=false, left=false;
int soul_size;//ソウルの大きさ
int soul_speed;//ソウルのスピード
int dead_time = 0;//soulのやられてからのフレーム数
float MAX_HP = 12;
float HP;
boolean soul_lose = false;
boolean soul_clashed = false;
class Soul
{
  float hit_up, hit_down, hit_right, hit_left;//当たり判定の基準となる点
  float x, y;

  Soul()
  {
    x = width/2;
    y = height/2;
  }


  void move()
  {
    if (soul_lose == false&& expiration == false)
    {
      //ソウルの移動処理
      if (up) {
        y-=soul_speed;
      }
      if (down) {
        y+=soul_speed;
      }
      if (right) {
        x+=soul_speed;
      }
      if (left) {
        x-=soul_speed;
      }
      //枠からソウルがはみ出ないようにする処理　
      //右端
      if (x < frame_x_1+soul_size/2)
      {
        x = frame_x_1+soul_size/2;
      }
      //左端
      if (x > frame_x_1+frame_width_1-soul_size/2)
      {
        x = frame_x_1+frame_width_1-soul_size/2;
      }
      //上端
      if (y < frame_y_1+soul_size/2)
      {
        y = frame_y_1+soul_size/2;
      }
      //下端
      if (y > frame_y_1+frame_height_1-soul_size/2)
      {
        y = frame_y_1+frame_height_1-soul_size/2;
      }
    }
    hit_left = x - soul_size/2;
    hit_right = x + soul_size/2;
    hit_up = y - soul_size/2;
    hit_down = y + soul_size/2;
    if (soul_lose == false)//通常時のsoul表示
    {
      imageMode(CENTER);
      tint(255, 255);
      image(player_soul, x+vx, y+vy, soul_size, soul_size);
      fill(255);
    }
    if (HP <= 0)//soulやられ時の処理
    {
      soul_lose = true;
    }
  }

  void action()
  {  
    dead_time++;
    if ( soul_lose == true&&dead_time == 1)//soulやられ直後の処理
    {
      dead.play();
      dead.rewind();
    }
    if (soul_lose == true&&dead_time < 120)//やられてから2秒後まで実行
    {
      imageMode(CENTER);
      image(soul_dead, x, y, soul_size, soul_size);
    } 

    if ( soul_lose == true&&dead_time == 120)//やられた2秒後soulを砕く
    {
      crash.play();
      crash.rewind();
      for (int i = 0; i < 50; i++)
      {
        piaces.add(new Clash(soul.x, soul.y));
      }
    }
    if (soul_lose == true&&dead_time == 240)//やられた4秒後に終了画面表示
    {
      soul_clashed = true;
    }
  }
}
//----------------------------------------------------------------------------------
class Clash
{
  float x, y, rad, addX, addY;
  int frame = 0;
  float gravity = 0.1;
  boolean needbreak = false;
  Clash(float _x, float _y) {
    x = _x;
    y = _y;
    rad = random(0, TWO_PI);
    addX = random(1, 5)*cos(rad);
    addY = random(1, 5)*sin(rad);
    
  }
  void update() {
    frame++;
    if(x<0||x>width||y<0||y>height||frame>15){
      //needbreak = true;
    }
    x+=addX;
    addY += gravity;
    y+=addY;
  }
  void drawing() {
    fill(255,0,0);
    noStroke();
    ellipse(x, y, width/273, height/153);
  }
}
