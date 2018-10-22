int start = 0;
void bgm()//シーンに合わせてbgmを流す
{
  if (Start_Menu.isPlaying() == false&&game_start == false)
  {
    Game_fin.pause();
    Game_fin.rewind();
    Battle_bgm.pause();
    Battle_bgm.rewind(); 
    Start_Menu.rewind();
    Start_Menu.play();
  }
  if (game_start&&soul_lose == false&&expiration == false)
  {
    Start_Menu.pause();
    Battle_bgm.play();
  }
  if (soul_lose||expiration)
  {
    Battle_bgm.pause();
  } 
  if (fin && Game_fin.isPlaying() == false)
  {
    Game_fin.rewind();
    Game_fin.play();
  }
}
//----------------------------------------------------------------------------------
//振動処理
void vibration(float size)
{
 vx = random(-size,size);
 vy = random(-size,size);
}
