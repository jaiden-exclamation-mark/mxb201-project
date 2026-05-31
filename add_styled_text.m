function add_styled_text(x, y, displayString, textColor)
    t = text(x, y, displayString);
    t.Color = textColor;
    t.FontSize = 12;
    t.FontWeight = 'bold';
    t.BackgroundColor = 'k';
end