# Общее описание приложения

Я реализовал приложение, в котором можно смотреть новостные статьи по любой желаемой теме, фильтровать найденные статьи по популярности, актуальности и языку. Приложение также сохраняет историю запросов пользователя и позволяет сохранять понравившиеся воспоминания в избранные.

Мной использовалось открыток новостное API [https://newsapi.org/](https://newsapi.org).

# Архитектура

Была реализована **MVVM+R + Clean Architecture** архитектура.

# Использованный функционал

| Технология          | Описание                                                      |
|---------------------|---------------------------------------------------------------|
| **UIKit + SnapKit**  | Для вёрстки кодом                                             |
| **RxSwift**          | Для реактивного обновления UI при изменениях данных           |
| **FileManager**      | Для кэширования изображений статей, чтобы не загружать их заново |
| **SwiftData**        | Для хранения избранных статей                                 |
| **UserDefaults**     | Для хранения истории запросов                                 |
| **Moya**             | Для работы с запросами к API                                  |
| **SwiftLint**        | Для облегчения проверки соблюдения кодстайла                  |


## Пагинация

В функционал отображения статей внедрена пагинация. Когда пользователь долистает до нескольких последних элементов в таблице, будет отправлен дополнительный запрос к API для отображения следующих статей на экране.

Пагинация производится при помощи параметров `page` и `pageSize` внутри запроса к API.

## Работа с API, модуль NetworkKit

Работа с API осуществлялась при помощи фреймворка **Moya**. Я выделил весь Network-слой в отдельный модуль **NetworkKit**, которые **переиспользую** в своих проектах.

## Редактирование и удаление элементов локально

Пользователю доступна возможность сохранения понравившихся статей на устройстве локально.

## Динамическая высота ячеек

## Фильтрация 

В приложении можно фильтровать найденные статьи следующими способами:
- По языку (Русскому, Английскому, Немецкому, Французскому, Итальянскому)
- По параметрам сортировки (Популярности, Дате публикации)
- По языку и параметрам сортировки одновременно

На главном экране есть две кнопки для фильтрации: одна - для фильтрации по языку, вторая - для сортировки по параметрам. Когда данные фильтруются по одному из параметров, соответственная кнопка загорается **зелёным цветом**, а иначе - имеется **тусклый цвет**. _Этот функционал можно увидеть на скриншотах ниже._

**P.S.** Сортировка по **популярности** производится внутри API. А сама фильтрация производится при помощи параметров `language` и `sortBy` внутри запроса к API.

## Индикация подгрузки данных

# Скриншоты из приложения

## Все экраны приложения 

![613shots_so](https://github.com/user-attachments/assets/33042a0c-8100-43f0-8f3e-9b200029b6ba)

## Функционал фильтрации на главном экране

![948shots_so](https://github.com/user-attachments/assets/784aabee-5257-430d-84a0-3451bd8c757a)

## Индикация подгрузки данных

![441shots_so](https://github.com/user-attachments/assets/205a9d33-f7bb-494f-8aff-bebb760b0b90)
