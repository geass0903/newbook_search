enum Event {
  error, // エラー
  success, // 成功
  showProgress, // プログレス表示
  dismissProgress, // プログレス消去
  signIn, // ログイン成功
  signInError, // ログイン失敗
  signOut, // ログアウト成功
  signOutError, // ログアウト失敗
  signUp, // 新規登録成功
  signUpError, // 新規登録エラー
  register, // 登録成功
  registerError, // 登録失敗
  push, // プッシュ通知テスト成功
  pushError, // プッシュ通知テストエラー
  delete, // 削除
  update, // 更新
}
