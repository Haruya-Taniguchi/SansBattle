int cell = 6;//コマの数
PImage[] GSB_img;//gasterbraster（以下gsb）の画像の変数を宣言
class GSB
{
  boolean anime_fin = false;//初めの四コマのアニメーションが終わったらtrueになる
  boolean shot_fin = false;//ビームの太さが設定した最高値になったらtrueになる
  boolean shot = false;//撃つ動作の開始と同時にtureになる
  boolean shot_begin = false;//撃った瞬間trueになる

  float sx, sy;//出現、目標ポイントの調整
  int then_s;//撃った瞬間のf2ame_sの値を記録
  int frame = 0;//出現してからのフレーム数
  int frame_s = 0;//ショット関数実行を実行してからのフレーム数を記録する変数
  int frame_s2 = 0;//撃たれてからのフレーム数を記録する関数
  int t = 255;//ビームの透明度
  int t_fin = 50;//当たり判定がなくなるビームの透明度
  float sw = 10;//ビームの太さ
  int interval = 5;//アニメーションのコマを進める間隔
  float ene_cost;//出現時に消費されるenergy
  float degrees;//gasterbraster本体の向き
  float x, y;//gasterbrasterの座標
  float gsb_scall = 1.15;//gasterbrasterのサイズ
  float target_degrees=target_slide_way();//攻撃目標
  float gsb_degrees =  a_slide_degrees;//gsb本体の向き
  float app_size_width;//出現地点の幅
  float app_size_height;//出現地点の高さ
  float target_size_width;//目標地点の幅
  float target_size_height;//目標地点の高さ
  float range = (gsb_scall*GSB_img[1].width*1.4)/(sw/3);//当たり判定の範囲
  float app_point_x, app_point_y;//gasterbrasterの出現位置
  float target_point_x, target_point_y;//gasterbrasterの移動目標座標
  float move_x, move_y;//撃ったあとの移動に使用する変数
  float r = 5;//target_degrees+PIが90,270度に近い時の特別な当たり判定の調整用変数

  GSB()
  {
    ene_cost = 19;//gsbの出現時に消費されるenergy
    //枠の中心の周りに出現させる
    //sx = 0;
   //sy = 0;
    //ソウルの周りに出現させる
    sx = soul.x-frame_center_x;
    sy = soul.y-frame_center_y;
    //ソウルの周りに出現させる(自由度高め)
    //sx = soul.x-frame_center_x+(hand_x-width/2)/2;
    //sy = soul.y-frame_center_y+(hand_y-height/2)/1.5;

    //出現時の角度を指定する
    degrees = target_slide_way();

    //出現地点となる円の幅と高さ
    app_size_width = 1200;
    app_size_height = 1200;

    //目標地点となる円の幅と高さ
    target_size_width = 500;
    target_size_height = 500;

    //撃ったあとの移動に使用する変数
    move_x = 0;
    move_y = 0;

    //円状の出現地点と目標地点を設定
    app_point_x = cos(degrees+PI)*app_size_width+frame_center_x+sx;
    app_point_y =  sin(degrees+PI)* app_size_height+frame_center_y+sy;
    target_point_x = cos(degrees+PI)*target_size_width+frame_center_x+sx;
    target_point_y = sin(degrees+PI)* target_size_height+frame_center_y+sy;

    //gasterbrasterの初期位置
    x = app_point_x;
    y = app_point_y;
  }

  void app()
  {    

    frame++;
    if (frame == 1)
    {
      gsb_app.play();
      gsb_app.rewind();
      ene -= ene_cost;//energyを消費
    }

    if (shot == false)
    {
      out();
      x += (target_point_x-x)/5;
      y += (target_point_y-y)/5;
      display( GSB_img[0], x, y, gsb_degrees, gsb_scall);
    }
    if (frame > 60)//60フレーム後に攻撃
    {
      shot = true;
    }
  }

  void shot()
  {
    if (shot == true)
    {
      frame_s++;//発射動作後から経過したフレームを計測

      if (frame_s/interval < 4 )//0~3コマ目までframe_sの値によってコマを進める
      {     
        display(GSB_img[frame_s/interval], x, y, gsb_degrees, gsb_scall);
      } else
        //3コマ目以降は4コマ目と5コマ目を反復
        if (frame_s/interval > 3 && (frame_s/interval)% 2 == 0)
        { 
          anime_fin = true;
          shot_begin = true;
          display(GSB_img[4], x, y, gsb_degrees, gsb_scall);
          shot_effect();
        } else
          if (frame_s/interval > 3 && (frame_s/interval)%2 != 0)
          {
            display(GSB_img[5], x, y, gsb_degrees, gsb_scall);
            shot_effect();
          }
      if (anime_fin == true)//撃ったあとは出現地点方面に後退する
      {
        move_x +=0.03;
        move_y +=0.03;
        //徐々に加速させる
        x = cos(target_degrees+PI)*(target_size_width*(1+move_x*move_x))+frame_center_x+sx;
        y = sin(target_degrees+PI)*(target_size_height*(1+move_y*+move_y))+frame_center_y+sy;
      }

      if (t > 150&&shot_begin == true)//振動処理
      {
        vibration(gsb_scall*6);
      }
    }
  }

  void display(PImage img, float x, float y, float deg, float scall)
  {
    pushMatrix();
    translate(x, y);
    rotate(deg);
    //image(img, 0+vx, 0+vy, img.width*scall, img.height*scall);
    image(img, 0+vx, 0+vy,img.width*scall,img.height*scall);
    popMatrix();
  }

  void shot_effect()//gasterbrasterの攻撃のエフェクトを絵画する関数
  {
    if (frame_s2 == 0)
    {
      gsb_shot.play();
      gsb_shot.rewind();
    }
    frame_s2++;

    if (sw < (gsb_scall*GSB_img[1].width)/1.5 && shot_fin == false)
    {
      sw += pow(frame_s2/2, 3);
    } else {
      shot_fin = true;
    }
    if (shot_fin == true)
    {
      if (t > 0)
      {
        t -= 10;
      }
      if (sw > gsb_scall)
      {
        sw -= gsb_scall;
      }
    }
    stroke(255, t);
    strokeWeight(sw);
    line(x+cos(target_degrees)*gsb_scall*25+vx, y+sin(target_degrees)*gsb_scall*25+vy, cos(target_degrees)*3000+x+vx, sin(target_degrees)*3000+y+vy);
  }
  boolean hit()//当たり判定の処理
  {
    boolean hit = false;
    float hit_x, hit_y, hit_left, hit_right;//当たり判定の基準の座標
    hit_x = soul.x;
    hit_y = tan(target_degrees+PI)*(soul.x-x)+y;//中心
    hit_left = tan(target_degrees+PI)*(soul.hit_left-x)+y;//左端
    hit_right = tan(target_degrees+PI)*(soul.hit_right-x)+y;//右端
    if (t > t_fin)
    {
      if ((dist(soul.x, soul.y, hit_x, hit_y)<range||dist(soul.x, soul.y, hit_x, hit_left)<range||dist(soul.x, soul.y, hit_x, hit_right)<range)&&shot_begin == true)//当たり判定
      {
        hit = true;
      } else {
        hit = false;
      }  
      //target_degrees+PIが90,270度に近い時の特別な当たり判定
      if ((((degrees(target_degrees+PI)<270+r&&degrees(target_degrees+PI)>270-r)||(degrees(target_degrees+PI)<90+r)&&degrees(target_degrees+PI)>90-r)&&(soul.x<x+range&&soul.x>x-range))&&shot_begin == true)
      {
        hit = true;
      }
    }
    /*
    //当たり判定の基準となる円を表示
    if (hit == false)
    {
      fill(0, 0, 255);
    } else {
      fill(255, 0, 0);
    }  
    //中心
     noStroke();
     ellipse(hit_x, hit_y, range, range);
     //左端
     noStroke();
     ellipse(hit_x, hit_left, range, range);
     //右端
     noStroke();
     ellipse(hit_x, hit_right, range, range);
     */
    return hit;
  }
  boolean remove()
  {
    if ((700<dist(frame_x_1+ frame_width_1/2, frame_y_1+ frame_height_1/2, x, y)&&t < t_fin)||game_start == false)//画面よりある程度離れたらgasterbrasterのArrayListを削除
    {
      return true;
    } else {
      return false;
    }
  }

  float target_soul()//gasterbrasterから見たソウルに対する角度の値を返す関数
  {
    return atan2(soul.y-y, soul.x-x);
  }

  float target_slide_way()//スライドした角度を返す関数
  {
    return slide_degrees;
  }

  void out()//gsbが画面外にいる時の処理
  {
    if (target_point_x > width+gsb_scall*10||target_point_x < 0-gsb_scall*10||target_point_y > height+gsb_scall*10||target_point_y<0-gsb_scall*10)
    {
      textAlign(CENTER);
      if (frame%3 == 0)
      {
        fill(255);
      } else {
        fill(255, 0, 0);
      }
      pushMatrix();
      textFont(font2,60);
      translate(cos(degrees+PI)*(target_size_width/2)+frame_center_x+sx, sin(degrees+PI)* (target_size_height/2)+frame_center_y+sy);
      rotate(gsb_degrees+PI);
      textSize(80);
      text("↑", -245, 0);
      text("↑", 245, 0);
      textSize(60);
      text("WARMING", 0, 0);
      textAlign(LEFT);
      popMatrix();
    }
  }
}
