#Использовать "../../core"
#Использовать cli-selector

Перем Лог;

Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("a all", Ложь, "включить все установленные плагинов")
				.ВОкружении("GITSYNC_ENABLE_ALL_PLUGINS");
	
	Команда.Опция("i interactive", Ложь, "интерактивный выбор плагинов для включения")
				.Флаг();

	Команда.Аргумент("PLUGIN", "", "Имя установленного плагина")
				.ТМассивСтрок()
				.ВОкружении("GITSYNC_PLUGINS");

	Команда.Спек = "(-a | --all) | (-i | --interactive) | PLUGIN...";

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	ИменаПлагинов = Команда.ЗначениеАргумента("PLUGIN");
	ВсеУстановленные = Команда.ЗначениеОпции("all");
	ВыбратьПлагиныИнтерактивно = Команда.ЗначениеОпции("interactive");

	МенеджерПлагинов = ПараметрыПриложения.МенеджерПлагинов();
	
	Если ВсеУстановленные Тогда
		МенеджерПлагинов.ВключитьВсеПлагины();
	Иначе

		ВсеПлагины = МенеджерПлагинов.ПолучитьИндексПлагинов();

		Если ВыбратьПлагиныИнтерактивно Тогда
			ВыборВКонсоли = Новый ВыборВКонсоли("Выберите плагины к включению:");
			Для каждого Плагин Из ВсеПлагины Цикл
				Если Плагин.Значение.Включен() Тогда
					ИмяПлагина = Лев(Плагин.Ключ + "              ", 15) + " - включен";
				Иначе
					ИмяПлагина = Плагин.Ключ;
				КонецЕсли;
				ВыборВКонсоли.ДобавитьЗначениеВыбора(ИмяПлагина, , НЕ Плагин.Значение.Включен());
			КонецЦикла;
			ИменаПлагинов = ВыборВКонсоли.Выбрать();
		КонецЕсли;

		Для каждого Плагин Из ИменаПлагинов Цикл

			ИмяПлагина = СокрЛ(Плагин);
			НашлиПлагин = ВсеПлагины[ИмяПлагина];

			Если НашлиПлагин = Неопределено Тогда
				Сообщить(СтрШаблон("Нашли не установленный плагин: %1", Плагин));
				Продолжить;
			КонецЕсли;

			НашлиПлагин.Включить();

			Сообщить("Включен плагин: "+ ИмяПлагина);

		КонецЦикла;

	КонецЕсли;

	ПараметрыПриложения.ЗаписатьВключенныеПлагины();

КонецПроцедуры

Лог = ПараметрыПриложения.Лог();