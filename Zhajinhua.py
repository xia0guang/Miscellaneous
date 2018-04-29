def validate_round_ending(dict):
    sum = 0
    for player in dict:
        sum += dict[player]
    return sum == 0

def round_ending(dict):
    if validate_round_ending(dict):
        print('所有玩家和目前输赢总额: ' + str(players_dict))
    else:
        print('金额有错误, 请仔细查看: ' + str(players_dict))

def validate_number_involved_input(description = '请输入数字', seprator = ' ', number_index = 0, format = '0~9'):
    while True:
        try:
            input_str = input(description)
            input_str_array = input_str.split(seprator)
            if len(input_str_array) <= number_index:
                return input_str
            valid_num = int(input_str_array[number_index])
            return input_str
        except:
            print('输入格式错误, 请按照正确的格式输出: ' + format)
if __name__ == '__main__':
    players_str = input('请输入所有玩家姓名, 以空格符号为分隔符: ')
    players_array = players_str.split(' ')
    players_dict = {}
    for player in players_array:
        players_dict[player] = 0
    print('游戏开始!')
    has_preset = input('如果需要输入玩家历史数据, 请输入\'yes\', 否则按回车跳过: ')
    if has_preset == 'yes':
        for player in players_array:
            players_dict[player] = int(validate_number_involved_input('请输入玩家 ' + player + ' 的历史数据: '))
    default_bet = int(validate_number_involved_input('默认赌注: '))
    while True:
        round_ending(players_dict)
        raw_input = input('输入命令或者按回车来开始新的一个回合: ')
        if raw_input == 'quit' or raw_input == 'exit':
            break
        else:
            round_sum = 0
            round_players_dict = {}
            for player in players_array:
                round_players_dict[player] = default_bet
                round_sum += default_bet
            while True:
                print('本回合游戏数据: ' + str(round_players_dict))
                print('本回合赌池总和: ' + str(round_sum))
                round_raw_input = validate_number_involved_input('请输入玩家和本轮赌注, 以空格符号为分隔符: ', ' ', 1)
                if round_raw_input == 'end round' or round_raw_input == 'er':
                    winner = input('请输入本回合赢家: ')
                    if winner not in players_dict:
                        print('specify failed')
                        continue
                    for player in round_players_dict:
                        if player == winner:
                            players_dict[winner] += round_sum - round_players_dict[winner]
                        else:
                            players_dict[player] -= round_players_dict[player]
                    print('结束本轮')
                    break
                else:
                    player_bet = round_raw_input.split(' ')
                    if len(player_bet) < 2:
                        print('format is not correct, abort')
                        continue
                    player = player_bet[0]
                    bet = int(player_bet[1])
                    if player not in players_dict:
                        print('no player found, abort')
                        continue
                    round_players_dict[player] += bet
                    round_sum += bet


    

