package com.example.hrm.config.jackson;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.List;

public class LocalDateTimeFlexDeserializer extends JsonDeserializer<LocalDateTime> {

    private static final List<DateTimeFormatter> FORMATTERS = Arrays.asList(
            DateTimeFormatter.ISO_LOCAL_DATE_TIME,                  // 2025-10-19T10:20:30
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"),     // 2025-10-19 10:20:30
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"),        // 2025-10-19 10:20
            DateTimeFormatter.ISO_LOCAL_DATE                        // 2025-10-19
    );

    @Override
    public LocalDateTime deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        String text = p.getText();
        if (text == null || text.isBlank()) {
            return null;
        }
        String value = text.trim();

        // 우선 등록된 포맷들 시도
        for (DateTimeFormatter formatter : FORMATTERS) {
            try {
                if (formatter == DateTimeFormatter.ISO_LOCAL_DATE) {
                    LocalDate d = LocalDate.parse(value, formatter);
                    return d.atStartOfDay();
                } else {
                    return LocalDateTime.parse(value, formatter);
                }
            } catch (DateTimeParseException ignored) {
            }
        }

        // 소수점 초가 있는 경우(예: 2025-10-19T10:20:30.123) 추가 시도
        try {
            return LocalDateTime.parse(value, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS"));
        } catch (DateTimeParseException e) {
            throw new IOException("Invalid date-time format: " + value, e);
        }
    }
}
