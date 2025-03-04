# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Exercise.find_or_initialize_by(name: '踵上げ').update(
  difficulty: 2,
  minimum_reps_or_distance: 15,
  target_muscles: 'ふくらはぎ',
  is_cardio: false,
  description: '立ったままで、踵を上げ下げするエクササイズ。バランス感覚も鍛えられます。'
)

Exercise.find_or_initialize_by(name: 'スクワット').update(
  difficulty: 3,
  minimum_reps_or_distance: 10,
  target_muscles: '太もも、臀部',
  is_cardio: false,
  description: '足を肩幅に開いてしゃがむ動作を繰り返すエクササイズ。下半身を鍛えるのに効果的。'
)

Exercise.find_or_initialize_by(name: '腕立て伏せ').update(
  difficulty: 3,
  minimum_reps_or_distance: 10,
  target_muscles: '胸、腕、肩',
  is_cardio: false,
  description: '腕と肩を中心に鍛える代表的な体重エクササイズ。膝をついての簡易バージョンもあり。'
)

Exercise.find_or_initialize_by(name: 'プランク').update(
  difficulty: 4,
  minimum_reps_or_distance: 30,
  target_muscles: '体幹、腹部',
  is_cardio: false,
  description: '腕立て伏せの姿勢を保ちながら、体幹を鍛える静止エクササイズ。'
)

Exercise.find_or_initialize_by(name: 'クラムシェル').update(
  difficulty: 2,
  minimum_reps_or_distance: 15,
  target_muscles: '臀部、内転筋',
  is_cardio: false,
  description: '横になった状態で脚を開閉し、内転筋と臀部を鍛えるエクササイズ。'
)

Exercise.find_or_initialize_by(name: '腹筋').update(
  difficulty: 3,
  minimum_reps_or_distance: 15,
  target_muscles: '腹部',
  is_cardio: false,
  description: '腹筋を使って上体を持ち上げるシンプルなエクササイズ。'
)

Exercise.find_or_initialize_by(name: '背筋').update(
  difficulty: 3,
  minimum_reps_or_distance: 15,
  target_muscles: '背中',
  is_cardio: false,
  description: 'うつ伏せの状態で上体を持ち上げ、背中を鍛えるエクササイズ。'
)

Exercise.find_or_initialize_by(name: 'ランニング').update(
  difficulty: 4,
  minimum_reps_or_distance: 1000,
  target_muscles: '全身',
  is_cardio: true,
  description: '心肺機能を高めるために効果的な全身運動。短距離から始めて徐々に距離を伸ばせる。'
)

Exercise.find_or_initialize_by(name: 'ウォーキング').update(
  difficulty: 2,
  minimum_reps_or_distance: 1000,
  target_muscles: '全身',
  is_cardio: true,
  description: 'リラックスしながら心肺機能を高める軽い運動。ランニングよりも負荷が低い。'
)
