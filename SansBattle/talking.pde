Talk serif1;
Talk serif2;
Talk serif3;
Talk serif_dead1;
Talk serif_dead2;

PImage Balloon; //画像データ（全体372,吹き出し39）
int frame = 0;
int size = 30;
int space = 8;

class Talk 
{
  float x, y;
  int talk_frame;//talk関数実行開始から経過したフレーム数
  int c;//現在表示している文字の番号
  int p = 5;//次の文字を表示するまでの間
  boolean talk_fin;//話終わったらtrueになる
  boolean voice = true;
  String txt;//表示する文字列
  Talk(float Tx, float Ty, String Ttxt)
  {
    c = 0;
    num = 0;
    x = Tx;
    y = Ty;
    txt = Ttxt;
    talk_fin = false;
  }
  void talk()
  {

    imageMode(CORNER);
    image(Balloon, x+vx, y+vy);
    fill(0);
    textFont(font);
    textSize(size);
    textAlign(LEFT);
    text(txt.substring(0, c+1), x+80+vx, y+40+size+space+vy, 300, 140);//c番目の文字を表示する
    if (txt.charAt(c)==','||txt.charAt(c)=='.'||txt.charAt(c)=='　')//注意 substring()の0番は何も入っていない
    {
      voice = true;
      c = add(20, txt.length()-1);
    } else
      if (txt.charAt(c)==' ')
      {
        voice = false;
        c = add(1, txt.length()-1);
      } else {
        voice = true;
        c = add(5, txt.length()-1);
      }
    if (c == txt.length()-1)
    {
      talk_fin = true;
    }
  }
  int num;//add関数の返り値
  boolean started=false;
  int add(int pause, int length)//lengthの値になるまで一定の時間感覚で加算した値を返し、加算時にsansの音声が流れる。
  {
    if (num==0&&!started) {//add()が実行されたと同時にsansの音声を再生。
      sans_voice.play();
      sans_voice.rewind();
      started=true;
    }
    talk_frame ++;
    if (talk_frame % pause == 0&&num < length)
    {
      num++;
      if (voice)
      {
        sans_voice.play();
        sans_voice.rewind();
      }
    }  
    return num;
  }
  void ini()//各変数を初期化
  {
    c = 0;
    num = 0;
    talk_fin = false;
  }
}
//----------------------------------------------------------------------------------
float val;
boolean setup = false;
boolean already = false;
void serif()
{  
  if (r_time <= limit&&r_time > limit-3)
  {
    serif1.talk();
  } else
    if (r_time <= 30&&r_time > 27)
    {
      serif2.talk();
    } else
      if (r_time <= 15&&r_time > 12)
      {
        serif3.talk();
      }
  if (expiration&&expiration_time > 140&&expiration_time < 200)
  {
    serif_dead1.talk();
  }
  if (expiration&&expiration_time >= 250&&expiration_time < 400)
  {
    serif_dead2.talk();
  }
}
