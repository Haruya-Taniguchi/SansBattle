void ini()//初期化用関数
{
  set = 0;//設定画面の変数
  MAX_HP = 12;
  HP = MAX_HP;//HP初期化
  start_2 = 0;//制限時間初期化
  ene = ene_max;//ene初期化
  chage = false;
  fin = false;
  //ゲーム終了の条件となりうる変数を初期化
  soul_lose = false;
  soul_clashed = false;
  expiration_time = 0;
  expiration = false;
  crisis = false;//制限時間の表示に
  dead_time = 0;//soulのHPが0になってからのフレーム数
  //soulの座標をを初期化
  soul.x = width/2;
  soul.y = height/2;
  //gsbのパラメーター初期化
  ene_max = 100;//energyの最大値
  //sans制御用変数初期化
  slash_frame = 0;
  sans_t = 255;
  sans_dead = false;
  sans_disapp = false;
  //表示用変数の初期化
  fin_t = 0;//終了時の画面
  fin_text_t = 0;//ゲーム終了画面の文字の透明度
  text_t = 0;//スタート画面の文字の透明度
  //Talkクラスのインスタンスのパラメーター初期化
  serif1.ini();
  serif2.ini();
  serif3.ini();
  serif_dead1.ini();
  serif_dead2.ini();
}
