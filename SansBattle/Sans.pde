int i = 0;
float range_head = 2, range_body= 2.3;//sansの動きの大きさを決める変数
int sans_frame = 0;
int sans_t = 255;
int slash_frame = 0;//slashエフェクトのアニメーションのコマ
PImage sans_head;
PImage sans_body;
PImage sans_leg;
PImage sans_head_2;
PImage sans_body_2;
PImage sans_leg_2;
PImage sans_head_2_b;//やられた後の2枚目の画像
PImage sans_head_3;
PImage sans_head_4;
PImage sans_head_5;
float head_x, head_y;//sans頭部の座標
float body_x, body_y;//sans胴部の座標
float leg_x, leg_y;//sans脚部の座標
PImage[] slash;
boolean sans_dead = false;
boolean sans_disapp = false;

void sans(float x, float y)
{

  if (sans_dead == false&& expiration == false)//通常時のsans
  {
    leg_x=x+4+vx;
    leg_y=y+95+vy;
    body_x=x+(bx[i]*range_body)+vx;
    body_y=y+(by[i]*range_body)+vy;
    head_x= x+(hx[i]*range_head)+vx;
    head_y=y-86+(hy[i]*range_head)+vy;
    imageMode(CENTER);
    image(sans_leg, leg_x, leg_y);
    image(sans_body, body_x, body_y);
    if (r_time<=15) {
      image(sans_head_3, head_x, head_y);
    } else
      if (r_time<=30&&r_time>15) {
        image(sans_head_4, head_x, head_y);
      } else {
        image(sans_head, head_x, head_y);
      }
    sans_frame++;
    if (sans_frame%5 == 0)
    {
      if (i < 12)
      {
        i++;
      } else {
        i =0;
      }
    }
  } else {
    leg_x=x+4+vx;
    leg_y=y+95+vy;
    body_x=x+vx;
    body_y=y+vy;
    head_x= x+vx;
    head_y=y-86+vy;
  }
  //時間切れ時のsans
  if (expiration&&expiration_time == 1)
  {
    slash_se.play();
    slash_se.rewind();
  }
  if (expiration&&expiration_time <= 80)//時間が切れた後の80フレームの間sans静止及びslashエフェクト表示
  {
    imageMode(CENTER);
    image(sans_leg, leg_x, leg_y);
    image(sans_body, body_x, body_y);
    image(sans_head_2, head_x, head_y);
    if (expiration_time % 8 == 0&&  slash_frame < 6)
    {
      slash_frame ++;
    }
    if ( slash_frame < 6  )
    {
      image(slash[slash_frame], x, y);
    }
  }

  if (expiration&&expiration_time == 80)
  {
    sans_die.play();
    sans_die.rewind();
  }
  if (expiration&&expiration_time > 80&&expiration_time < 140)//sansやられ表示及び振動
  {
    imageMode(CENTER);
    imageMode(CENTER);
    image(sans_leg_2, leg_x, leg_y);
    image(sans_body_2, body_x, body_y);
    image(sans_head_2, head_x, head_y);
    vibration(20);
  }
  if (expiration&&expiration_time > 140&&expiration_time < 210)//しばらく静止
  {
    vibration(0);
    imageMode(CENTER);
    image(sans_leg_2, leg_x, leg_y);
    image(sans_body_2, body_x, body_y);
    image(sans_head_5, head_x, head_y);
  }
  if (expiration&&expiration_time >= 210&&expiration_time < 360)//目をつむる
  {
    imageMode(CENTER);
    image(sans_leg_2, leg_x, leg_y);
    image(sans_body_2, body_x, body_y);
    image(sans_head_2_b, head_x, head_y);
  }
  if (expiration_time == 360)//消滅時の効果音
  {
    dis_app.play();
    dis_app.rewind();
  }
  if (expiration&&expiration_time >= 360)//消滅処理
  {
    imageMode(CENTER);
    tint(255, sans_t);
    image(sans_leg_2, leg_x, leg_y);
    image(sans_body_2, body_x, body_y);
    image(sans_head_2_b, head_x, head_y);
    sans_t-= 5;
  }
  if (sans_t < -200)//しばらくしたらsans_disappをtrueにしてエンディング開始
  {
    sans_disapp = true;
  }
}
