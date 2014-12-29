# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.delete_all
Category.create([
                    { name: 'その他' },
                    { name: 'PC・周辺機器' },
                    { name: '家電・AV・カメラ' },
                    { name: '本・雑誌' },
                    { name: 'ビデオ' },
                    { name: 'おもちゃ・ゲーム' },
                    { name: 'ファッション' },
                    { name: 'アクセサリー・時計' },
                    { name: '雑貨・文房具' },
                    { name: '食品・飲料' }
                ])