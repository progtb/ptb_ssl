# Библиотека стандартных подсистем ПТБ

![Платформа 1С](https://img.shields.io/badge/1с_platform-8.3.20.1838-yellow.svg)
[![Доработки](https://img.shields.io/github/issues/progtb/ptb_ssl/enhancement.svg?color=green&label=Доработки)](https://github.com/progtb/ptb_ssl/labels/enhancement)
[![Ошибки](https://img.shields.io/github/issues/progtb/ptb_ssl/bug.svg?color=red&label=Ошибки)](https://github.com/progtb/ptb_ssl/labels/bug)
[![GitHub release](https://img.shields.io/github/release/progtb/ptb_ssl.svg)](https://github.com/progtb/ptb_ssl/releases)

## Что это?

Это набор общих объектов для унификации различных механизмов и кода.
Подсистемы:
* [БазоваяФункциональность](docs/БазоваяФункциональность.MD)
* ГрупповоеРедактированиеТабличныхЧастей
* ДлительныеОперации
* ИнтеграцияConfluence
* ИнтеграцияSlack
* ИнтернетСервисы
* ПомощникЗаполнения
* ПроведениеДокументов
* РаботаСФормулами

Дополнительно в каталоге epf можно найти полезные обработки, не вошедшие в состав библиотеки.

## Документация

* [История версий](docs/%D0%98%D1%81%D1%82%D0%BE%D1%80%D0%B8%D1%8F%20%D0%B2%D0%B5%D1%80%D1%81%D0%B8%D0%B9.MD)
* [раздел "Стандартные подсистемы ПТБ"](https://progtb.atlassian.net/wiki/spaces/ptbssl/) в нашей базе знаний

## Как собрать?

Создаете пустую конфигурацию и загружаете из файлов каталог `src`.

## Благодарности
* [1С](https://v8.1c.ru/) за отличную платформу (пусть и не без глюков)