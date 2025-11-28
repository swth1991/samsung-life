#!/bin/bash
# PlantUML 다이어그램을 이미지로 렌더링하는 스크립트

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLANTUML_SERVER="http://www.plantuml.com/plantuml"

echo "PlantUML 다이어그램 렌더링 시작..."
echo ""

# component_diagram 렌더링
if [ -f "$SCRIPT_DIR/component_diagram.puml" ]; then
    echo "렌더링 중: component_diagram.puml -> component_diagram.png"
    curl -o "$SCRIPT_DIR/component_diagram.png" \
         "$PLANTUML_SERVER/png/$(cat "$SCRIPT_DIR/component_diagram.puml" | python3 -c "import sys, zlib, base64; sys.stdout.write(base64.b64encode(zlib.compress(sys.stdin.buffer.read(), 9)).decode('utf-8'))" 2>/dev/null || cat "$SCRIPT_DIR/component_diagram.puml" | gzip | base64 | tr -d '\n')" 2>/dev/null
    
    if [ $? -eq 0 ] && [ -f "$SCRIPT_DIR/component_diagram.png" ]; then
        # PNG 파일인지 확인 (PlantUML 오류는 HTML로 반환됨)
        if file "$SCRIPT_DIR/component_diagram.png" | grep -q "PNG"; then
            echo "✓ 완료: component_diagram.png"
        else
            echo "✗ 오류: component_diagram.puml 렌더링 실패"
            rm -f "$SCRIPT_DIR/component_diagram.png"
        fi
    else
        echo "✗ 오류: component_diagram.puml 렌더링 실패"
    fi
else
    echo "✗ 파일을 찾을 수 없습니다: component_diagram.puml"
fi

echo ""

# class_diagram 렌더링
if [ -f "$SCRIPT_DIR/class_diagram.puml" ]; then
    echo "렌더링 중: class_diagram.puml -> class_diagram.png"
    curl -o "$SCRIPT_DIR/class_diagram.png" \
         "$PLANTUML_SERVER/png/$(cat "$SCRIPT_DIR/class_diagram.puml" | python3 -c "import sys, zlib, base64; sys.stdout.write(base64.b64encode(zlib.compress(sys.stdin.buffer.read(), 9)).decode('utf-8'))" 2>/dev/null || cat "$SCRIPT_DIR/class_diagram.puml" | gzip | base64 | tr -d '\n')" 2>/dev/null
    
    if [ $? -eq 0 ] && [ -f "$SCRIPT_DIR/class_diagram.png" ]; then
        # PNG 파일인지 확인
        if file "$SCRIPT_DIR/class_diagram.png" | grep -q "PNG"; then
            echo "✓ 완료: class_diagram.png"
        else
            echo "✗ 오류: class_diagram.puml 렌더링 실패"
            rm -f "$SCRIPT_DIR/class_diagram.png"
        fi
    else
        echo "✗ 오류: class_diagram.puml 렌더링 실패"
    fi
else
    echo "✗ 파일을 찾을 수 없습니다: class_diagram.puml"
fi

echo ""
echo "렌더링 완료!"

