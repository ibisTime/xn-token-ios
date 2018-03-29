### 0.如果想添加币种 在 `CoinUtil` 中  `+ (NSArray *)shouldDisplayCoinArray` 添加对应的币种即可，并设置相应的单位

### 1.定制推送消息内容，主要是推送内容的定制
`ChatViewController 中， - (void)sendMsg:(IMAMsg *)msg`

### 2.ChatViewController, 以下方法中定义了系统消息的展示方式
`- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath`,
`ChatSysMsgCell`

### 3.todo
1.正在聊天时如果有

### 4.TIMBaseTableViewCell 中设置头像和昵称

