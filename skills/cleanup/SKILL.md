---
name: cleanup
description: 프로젝트 전체 파일을 훑어 남아있는 디버그 로그, 주석 처리된 코드, 사용하지 않는 import를 정리한다. /cleanup으로 명시적 호출.
---

# /cleanup

프로젝트 전체 파일을 훑어 남아있는 디버그 로그, 주석 처리된 코드, 사용하지 않는 import를 정리한다.

- 대상은 위 세 범주로 한정한다. 그 외의 리팩토링·스타일 변경은 하지 않는다 (전역 지침(CLAUDE.md/AGENTS.md)의 "Surgical Changes" 원칙).
- 의도적으로 남긴 것인지 애매한 항목은 지우지 말고 목록으로 보고한다.
