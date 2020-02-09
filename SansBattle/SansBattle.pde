//ライブラリをインポート
import de.voidplus.leapmotion.*;
import ddf.minim.*;  

//LeepMotion関連
LeapMotion leap;//LeepMotionクラスのインスタンスを宣言

//音声関連
Minim minim;
AudioPlayer gsb_app;  
AudioPlayer gsb_shot;
AudioPlayer dead;
AudioPlayer crash;
AudioPlayer damage;
AudioPlayer Battle_bgm;
AudioPlayer Game_fin;
AudioPlayer Start_Menu;
AudioPlayer battle_start;
AudioPlayer sans_die;
AudioPlayer dis_app;
AudioPlayer slash_se;
AudioPlayer retry;
AudioPlayer sans_voice;  
AudioPlayer warning;
AudioPlayer select;

//画像関連
PImage UI;//UI画像
//フォント関連
PFont font;//セリフ用フォント
PFont font2;//各種表示用フォント
PFont font3;//サイズの大きいフォント

//GSB関連
boolean shot = false;
ArrayList<GSB> gsbs;//GSBクラス型のArrayListのインスタンスを宣言

//ソウル関連
Soul soul;//Soulクラスのインスタンスsoulを宣言
ArrayList<Clash> piaces;//ソウルが砕けたときのエフェクト

//振動処理に使う変数
float vx, vy;

//sansのモーションに使う配列
float hx[] ={0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 1, 1, 1}, hy[]={0, -1, -1, -1, 0, 1, 1, 0, -1, -1, -1, 0, 1}, bx[]={0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 1, 1, 1}, by[]={0, 0, -1, 0, 0, 1, 0, 0, 0, -1, 0, 0, 1};
//ゲーム開始後のフレームを記録
int start_2 = 0;

//出現数管理用変数
boolean app_permit = true;
void setup()
{
  imageMode(CENTER);
  fullScreen(P2D);//フルスクリーンでプレイするときは画面解像度を1680x1050にしてください
  //size(1680,1050,P2D);
  soul_size = 24;//ソウルの大きさ
  soul_speed = 4;//ソウルのスピード
  //枠のサイズに関する変数
  frameWeight = 10;//枠の太さ
  frame_x_1= 455;//枠のx座標
  frame_y_1= 420;//枠のy座標
  frame_width_1= width/2.13;//枠の幅
  frame_height_1= 400;//枠の高さ
  frame_center_x = frame_x_1+ frame_width_1/2;//枠の中心のx座標
  frame_center_y = frame_y_1+ frame_height_1/2;//枠の中心のy座標
  //ソウル関連
  soul = new Soul();
  piaces = new ArrayList<Clash>();

  //GSB関連
  gsbs = new ArrayList<GSB>();//ArrayListのインスタンスgsbsを作成

  //leepmotion
  leap = new LeapMotion(this);//インスタンスleepを作成

  //音声
  minim = new Minim(this);  
  gsb_app = minim.loadFile("ガスターブラスター（出現）.wav"); 
  gsb_shot = minim.loadFile("ガスターブラスター（発射）.wav");
  dead = minim.loadFile("死亡時の効果音.wav");
  crash = minim.loadFile("ソウルが砕ける音.wav");
  damage = minim.loadFile("ダメージ.wav");
  battle_start = minim.loadFile("戦闘開始2.wav");
  sans_die = minim.loadFile("敵やられ.wav");
  dis_app = minim.loadFile("消え去る音.wav");
  slash_se = minim.loadFile("切り裂く.wav");
  retry = minim.loadFile("システム音2.wav");
  sans_voice = minim.loadFile("sansの声.wav");
  warning = minim.loadFile("警告.wav");
  select = minim.loadFile("システム音5.wav");
  //BGM
  Start_Menu = minim.loadFile("Once Upon A Time.mp3");
  Battle_bgm = minim.loadFile("Megalovania.mp3");
  Game_fin = minim.loadFile("Determination.mp3");
  //画像
  player_soul = loadImage("soul.png");//プレイヤーのソウルの画像をロード
  soul_dead = loadImage("soul_やられ.png");//プレイヤーのソウルの画像をロード
  UI = loadImage("UI.png");//背景画像をロード
  title = loadImage("title.png");//タイトル画面背景
  player_1_win = loadImage("player_1_win.png");
  player_2_win = loadImage("player_2_win.png");
  sans_head = loadImage("sans_head_1.png");
  sans_leg = loadImage("sans_leg.png");
  sans_body = loadImage("sans_body.png");
  sans_head_2 = loadImage("sans_head_6.png");
  sans_leg_2 = loadImage("sans_leg_dead.png");
  sans_body_2 = loadImage("sans_body_dead.png");
  sans_head_2_b = loadImage("sans_head_7.png");
  sans_head_3 = loadImage("sans_head_2.png");
  sans_head_4=loadImage("sans_head_3.png");
  sans_head_5=loadImage("sans_head_5.png");
  Balloon = loadImage("Balloon.png");
  //gasterbrasterの画像をロード
  GSB_img = new PImage[cell];//配列を作成
  for (int i = 1; i <= GSB_img.length; i++) //配列の大きさだけfor文を回す
  {
    GSB_img[i-1] = loadImage("gsb_" + i + ".png");//gasterbrasterの画像をロード
  }
  //エフェクト画像
  slash = new PImage[6];
  for (int i= 1; i <= slash.length; i++)
  {
    slash[i-1] = loadImage("slash_"+i+".png");
  }
  //フォントをロード
  font = loadFont("DeterminationJP-48.vlw");
  font2 = loadFont("FAMania-48.vlw");//仮名文字とアルファベット
  font3 = loadFont("DeterminationJP-180.vlw");
  //sansのセリフ
  serif1 = new Talk(width/2+80, 50, "やるか.");
  serif2 = new Talk(width/2+80, 50, "あと30ビョウか.      やるな.");
  serif3 = new Talk(width/2+80, 50, "そろそろヤバイな.         ホンキでいかせてもらうぜ.");
  serif_dead1 = new Talk(width/2+80, 50, "...");
  serif_dead2 = new Talk(width/2+80, 50, "どうやら,ここまでみたいだな.");
}
void draw()
{
  background(0);
  noCursor();
  if ( leap.isConnected()) {//leapmotionが接続されていない場合マウスで操作できるようになる
    leepMotion();
  } else {
    mouse();
  }
  start ++;//プログラム開始後のフレームを測る
  bgm();//シーンに合わせてbgmを流す
  if (game_start == false)
  {
    if (set == 0)
    {
      title();
    } else
      if (set <= 4)
      {
        setting();
      }
    for (int i = 0; i < gsbs.size(); i++)//gsbを全て削除
    {
      gsbs.remove(i);
    }
  }
  if (game_start)//ゲーム開始後の処理
  {
    start_2 ++;
    player();
    if (soul_clashed)

    {
      fin(1);
    } else
      if (sans_disapp)
      {
        fin(2);
      } else
        if (expiration)
        {
          time_limit();
          frame();//枠を表示
          display();
          soul.move();//soulの移動処理
          soul.action();//soulがやられた後の処理
          tint(255, 255);
          image(UI, width/2+vx, 950+vy, UI.width/2, UI.height/2);
          sans(width/2, 250);//sans表示
          expiration_time++;
        } else
          if (soul_lose == false)
          {
            time_limit();
            frame();//枠を表示
            display();
            soul.move();//soulの移動処理
            tint(255, 255);
            image(UI, width/2+vx, 950+vy, UI.width/2, UI.height/2);
            sans(width/2, 250);//sans表示
          }

    if (soul_lose)
    {
      soul.action();//soulがやられた後の処理
    }

    if (slide == true&&Pslide == false)//スライド動作が始まったら
    {
      if (soul_lose == false&&expiration == false&&chage == false&&app_permit&&game_start)//チャージ中はgbs出現不可
      {
        gsbs.add(new GSB());//gasterbrasterを一体増やす
      }
    }

    if (soul_lose == false&&expiration == false&&game_start)
    {
      ene();//eneのゲージを表示
      //GSB関連の処理
      for (int i = 0; i < gsbs.size(); i++)//ArrayListの数だけfor文を回す
      {
        GSB gsb = gsbs.get(i);
        if (gsb.remove())
        {
          gsbs.remove(i);
          i--;
        }
        if (gsb.hit()&&soul_lose==false)//当たり判定があった時の処理
        {
          if (gsb.frame_s2 % 6 == 0)// 6フレームごとに１ダメージ
          {
            damage.play();
            damage.rewind();
            HP-=1;//ダメージを与える
          }
        }
        gsb.shot();//射撃処理
        gsb.app();//出現時の処理
      }
    }

    //soulやられ時のエフェクト処理
    for (int i = 0; i < piaces.size(); i++)
    {
      Clash clash = piaces.get(i);
      clash.update();
      clash.drawing();
    }
    if (soul_lose == false&&sans_disapp == false)
    {
      serif();
    }
  }
  if (leap.isConnected()) {//カーソル表示
    hand_cursor(hand_x, hand_y, hand_z);
  }else{
    hand_cursor(mouseX,mouseY,0);
  }
}
