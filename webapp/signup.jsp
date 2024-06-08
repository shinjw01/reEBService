<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>EBS | 회원가입</title>
    <link rel="stylesheet" href="./css/reset.css" />
    <link rel="stylesheet" href="./css/global.css" />
    <link rel="stylesheet" href="./css/signup.css?after" />
</head>
<body>
    <div class="signup-box">
        <h2 class="signup-title">회원 가입</h2>
        <div class="signup-container">
            <form id="signup-form" action="signup_verify.jsp" method="post">
                <div class="signup-content">
                    <p>이름</p>
                    <div class="signup-content-input">
                        <input
                            type="text"
                            name="user_name"
                            id="name"
                            maxlength="10"
                            placeholder="10글자 이내 한글로 작성해주세요."
                            onblur="validateName()"
                            oninput="validateForm()"
                        />
                        <span id="nameCheck"></span>
                    </div>
                </div>

                <div class="signup-content">
				    <p>아이디</p>
				    <div class="signup-content-input">
				        <div class="signup-content-input-duplication">
				            <input
				                type="text"
				                name="user_id"
				                id="id"
				                minlength="5"
				                placeholder="영어, 숫자 조합의 5 - 15자로 작성해주세요."
				                onblur="validateId()"
				                oninput="resetIdDuplicationStatus(); validateId(); validateForm()"
				            />
				            <button type="button" id="duplicationButton" onclick="checkIdDuplication()" disabled>중복 확인</button>
				        </div>
				        <span id="idCheck"></span>
				    </div>
				</div>


                <div class="signup-content">
                    <p>이메일</p>
                    <div class="signup-content-input">
                        <input
                            type="email"
                            name="email"
                            id="email"
                            placeholder="ebservice@sookmyung.ac.kr"
                            onblur="validateEmail()"
                            oninput="validateForm()"
                        />
                        <span id="emailCheck"></span>
                    </div>
                </div>

                <div class="signup-content">
                    <p>비밀번호</p>
                    <div class="signup-content-input">
                        <input
                            type="password"
                            name="password"
                            id="password"
                            minlength="8"
                            placeholder="영어, 숫자 조합의 8 - 24자로 작성해주세요."
                            onblur="validatePassword()"
                            oninput="validateForm()"
                        />
                        <span id="passwordCheck"></span>
                    </div>
                </div>

                <div class="signup-content">
                    <p>비밀번호 확인</p>
                    <div class="signup-content-input">
                        <input
                            type="password"
                            id="passwordConfirm"
                            placeholder="비밀번호를 다시 입력해주세요."
                            onblur="validatePasswordConfirm()"
                            oninput="validateForm()"
                        />
                        <span id="passwordConfirmCheck"></span>
                    </div>
                </div>

                <div class="signup-content">
                    <p>생년월일</p>
                    <div class="signup-content-input">
                        <input
                            type="text"
                            name="birth"
                            id="birthDate"
                            placeholder="생년월일 8자리를 입력해주세요. (YYYYMMDD)"
                            onblur="validateBirthDate()"
                            oninput="validateForm()"
                        />
                        <span id="birthDateCheck"></span>
                    </div>
                </div>

                <div class="signup-content">
                    <p>휴대폰 번호</p>
                    <div class="signup-content-input">
                        <input
                            type="tel"
                            name="phone"
                            id="phoneNumber"
                            pattern="[0-9]{11}"
                            placeholder="하이픈(-)을 제외한 숫자만 입력해주세요."
                            onblur="validatePhoneNumber()"
                            oninput="validateForm()"
                        />
                        <span id="phoneNumberCheck"></span>
                    </div>
                </div>
                <div class="sign-button-container">
                    <button id="signup-button" type="submit" disabled>가입하기</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // 이름 유효성 검사
        function checkValidationForName() {
            const regName = /^[가-힣]{2,10}$/;
            const nameInputElement = document.getElementById("name");

            if (nameInputElement.value === "") {
                return { isError: true, message: "필수 입력 항목입니다!" };
            } else if (!regName.test(nameInputElement.value)) {
                return { isError: true, message: "이름은 10자 이내 한글로 구성해주세요!" };
            } else {
                return { isError: false, message: "" };
            }
        }

        // 아이디 유효성 검사
        function checkValidationForId() {
            const regId = /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9]{5,15}$/;
            const idInputElement = document.getElementById("id");

            if (idInputElement.value === "") {
                return { isError: true, message: "필수 입력 항목입니다!" };
            } else if (!regId.test(idInputElement.value)) {
                return { isError: true, message: "아이디는 영어와 숫자를 조합하여 5-15자로 작성해주세요." };
            } else if (!idInputElement.dataset.checked) {
                return { isError: true, message: "아이디 중복 확인을 해주세요." };
            } else {
                return { isError: false, message: "중복 확인이 완료되었습니다." };
            }
        }

        // 아이디 중복확인 후 아이디를 수정한 경우
        function resetIdDuplicationStatus() {
            const idInputElement = document.getElementById("id");
            idInputElement.dataset.checked = "";
            document.getElementById("idCheck").innerText = "아이디 중복 확인을 해주세요.";
        }

        // 중복 확인 버튼 상태 업데이트
        function updateDuplicationButtonStatus() {
            const regId = /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9]{5,}$/;
            const idInputElement = document.getElementById("id");
            const duplicationButton = document.getElementById("duplicationButton");

            if (regId.test(idInputElement.value)) {
                duplicationButton.disabled = false;
            } else {
                duplicationButton.disabled = true;
            }
        }

        // 아이디 유효성 검사
        function validateId() {
            const result = checkValidationForId();
            document.getElementById("idCheck").innerText = result.message;
            updateDuplicationButtonStatus();
            validateForm();  // 폼 전체 유효성 검사
        }

        // 아이디 중복 확인
        function checkIdDuplication() {
            const userId = document.getElementById("id").value;
            if (userId === "") {
                alert("아이디를 입력해주세요.");
                return;
            }

            const xhr = new XMLHttpRequest();
            xhr.open("POST", "signup_verify.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    const response = JSON.parse(xhr.responseText);
                    if (response.isAvailable) {
                        alert(response.message);
                        document.getElementById("id").dataset.checked = "true";
                        document.getElementById("idCheck").innerText = "중복 확인이 완료되었습니다!";
                    } else {
                        alert(response.message);
                        document.getElementById("id").dataset.checked = "";
                        document.getElementById("idCheck").innerText = response.message;
                    }
                    validateForm();  // 폼 전체 유효성 검사
                }
            };
            xhr.send("check_id=true&user_id=" + encodeURIComponent(userId));
        }

        // 페이지 로드 시 초기 버튼 상태 설정
        document.addEventListener("DOMContentLoaded", function() {
            updateDuplicationButtonStatus();
        });

        // 이메일 유효성 검사
        function checkValidationForEmail() {
            const regEmail = /^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)*\w[\w-]{0,66}\.[a-z]{2,6}(?:\.[a-z]{2})?$/;
            const emailInputElement = document.getElementById("email");

            if (emailInputElement.value === "") {
                return { isError: true, message: "필수 입력 항목입니다!" };
            } else if (!regEmail.test(emailInputElement.value)) {
                return { isError: true, message: "올바른 메일 형식이 아닙니다!" };
            } else {
                return { isError: false, message: "" };
            }
        }

        // 이메일 유효성 검사
        function validateEmail() {
            const result = checkValidationForEmail();
            document.getElementById("emailCheck").innerText = result.message;
            validateForm();  // 폼 전체 유효성 검사
        }

        // 비밀번호 유효성 검사
        function checkValidationForPassword() {
            const regPassword = /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,25}$/;
            const passwordInputElement = document.getElementById("password");

            if (passwordInputElement.value === "") {
                return { isError: true, message: "필수 입력 항목입니다!" };
            } else if (!regPassword.test(passwordInputElement.value)) {
                return { isError: true, message: "영어+숫자를 조합하여 8자 이상 작성해주세요." };
            } else {
                return { isError: false, message: "" };
            }
        }

        // 비밀번호 유효성 검사
        function validatePassword() {
            const result = checkValidationForPassword();
            document.getElementById("passwordCheck").innerText = result.message;
            validateForm();  // 폼 전체 유효성 검사
        }

        // 비밀번호 확인 유효성 검사
        function checkValidationForPasswordConfirm() {
            const passwordConfirmInputElement = document.getElementById("passwordConfirm");

            if (passwordConfirmInputElement.value === "") {
                return { isError: true, message: "비밀번호를 입력해주세요!" };
            } else if (passwordConfirmInputElement.value !== document.getElementById("password").value) {
                return { isError: true, message: "비밀번호가 일치하지 않습니다." };
            } else {
                return { isError: false, message: "" };
            }
        }

        // 비밀번호 확인 유효성 검사
        function validatePasswordConfirm() {
            const result = checkValidationForPasswordConfirm();
            document.getElementById("passwordConfirmCheck").innerText = result.message;
            validateForm();  // 폼 전체 유효성 검사
        }

        // 생년월일 유효성 검사
        function checkValidationForBirthDate() {
            const birthDateInputElement = document.getElementById("birthDate");
            const regex = /^\d{8}$/;

            if (birthDateInputElement.value === "") {
                return { isError: true, message: "필수 입력 항목입니다!" };
            } else if (!regex.test(birthDateInputElement.value)) {
                return { isError: true, message: "생년월일은 YYYYMMDD 형식으로 입력해야 합니다." };
            }

            const year = parseInt(birthDateInputElement.value.substring(0, 4), 10);
            const month = parseInt(birthDateInputElement.value.substring(4, 6), 10);
            const day = parseInt(birthDateInputElement.value.substring(6, 8), 10);

            // 월과 일이 유효한지 체크
            if (month < 1 || month > 12 || day < 1 || day > 31) {
                return { isError: true, message: "유효하지 않은 날짜입니다." };
            }

            // 윤년 체크
            const isLeapYear = (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0);
            const daysInMonth = [31, isLeapYear ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

            if (day > daysInMonth[month - 1]) {
                return { isError: true, message: "유효하지 않은 날짜입니다." };
            }

            return { isError: false, message: "" };
        }

        // 생년월일 유효성 검사
        function validateBirthDate() {
            const result = checkValidationForBirthDate();
            document.getElementById("birthDateCheck").innerText = result.message;
            validateForm();  // 폼 전체 유효성 검사
        }

        // 휴대폰 번호 유효성 검사
        function checkValidationForPhoneNumber() {
            const phoneNumberInputElement = document.getElementById("phoneNumber");
            const regex = /^\d{11}$/;

            if (phoneNumberInputElement.value === "") {
                return { isError: true, message: "필수 입력 항목입니다!" };
            } else if (!regex.test(phoneNumberInputElement.value)) {
                return { isError: true, message: "휴대폰 번호는 11자리 숫자로 입력해야 합니다." };
            }

            return { isError: false, message: "" };
        }

        // 휴대폰 번호 유효성 검사
        function validatePhoneNumber() {
            const result = checkValidationForPhoneNumber();
            document.getElementById("phoneNumberCheck").innerText = result.message;
            validateForm();  // 폼 전체 유효성 검사
        }

        // 모든 입력 필드 유효성 검사 및 가입 버튼 활성화
        function validateForm() {
            const nameValidation = checkValidationForName();
            const idValidation = checkValidationForId();
            const emailValidation = checkValidationForEmail();
            const passwordValidation = checkValidationForPassword();
            const passwordConfirmValidation = checkValidationForPasswordConfirm();
            const birthDateValidation = checkValidationForBirthDate();
            const phoneNumberValidation = checkValidationForPhoneNumber();

            const isFormValid =
                !nameValidation.isError &&
                !idValidation.isError &&
                !emailValidation.isError &&
                !passwordValidation.isError &&
                !passwordConfirmValidation.isError &&
                !birthDateValidation.isError &&
                !phoneNumberValidation.isError;

            document.getElementById("signup-button").disabled = !isFormValid;
        }
    </script>
</body>
</html>
