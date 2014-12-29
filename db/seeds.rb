# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.delete_all
Category.create([
                    { code: 1000, name: 'PC・周辺機器' },
                    { code: 1100, name: '家電・AV・カメラ' },
                    { code: 1200, name: '本・雑誌' },
                    { code: 1300, name: 'ビデオ' },
                    { code: 1400, name: 'おもちゃ・ゲーム' },
                    { code: 1500, name: 'ファッション' },
                    { code: 1600, name: 'アクセサリー・時計' },
                    { code: 1700, name: '雑貨・文房具' },
                    { code: 1800, name: '食品・飲料' },
                    { code: 9999, name: 'その他' }
                ])