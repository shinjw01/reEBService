<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>EBS | 회원가입</title>
	<link rel="stylesheet" href="/css/signup.css" />
	<link rel="stylesheet" href="/css/reset.css" />
	<link rel="stylesheet" href="/css/main.css" />
</head>
<body>
	<div class="signup-page">
		<div class="signup-box">
			<h2 class="signup-title">회원 가입</h2>

			<div class="signup-container">
				<form action="signup_verify.jsp" method="post">
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
							<input
								type="text"
								name="user_id"
								id="id"
								minlength="8"
								placeholder="영어+숫자를 조합하여 8자 이상 작성해주세요."
								onblur="validateId()"
								oninput="validateForm()"
							/>
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
								placeholder="영어+숫자를 조합하여 8자 이상 작성해주세요."
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
								type="date"
								name="birth"
								id="birthDate"
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
								pattern="[0-9]{3}-[0-9]{3,4}-[0-9]{4}"
								placeholder="010-1234-5678"
								onblur="validatePhoneNumber()"
								oninput="validateForm()"
							/>
							<span id="phoneNumberCheck"></span>
						</div>
					</div>
					<div class='sign-button-container'>

					<button id="signup-button" type="submit" disabled>가입하기</button>
					</div>
				</form>
			</div>

			<div class="signup-completion-modal-overlay" style="display: none">
				<div class="signup-completion-modal">
					<h2>가입 성공!</h2>
					<p>EBService 가입을 축하합니다!!</p>
					<div class="signup-completion-modal-button-wrapper">
						<button onclick="handleSignUpCompletionModalCloseButtonClick()">로그인하러 가기</button>
					</div>
				</div>
			</div>
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
				return { isError: false, message: "멋진 이름이네요!" };
			}
		}

		// 아이디 유효성 검사
		function checkValidationForId() {
			const regId = /^[a-zA-Z0-9]{8,}$/;
			const idInputElement = document.getElementById("id");

			if (idInputElement.value === "") {
				return { isError: true, message: "필수 입력 항목입니다!" };
			} else if (!regId.test(idInputElement.value)) {
				return { isError: true, message: "아이디는 영어+숫자를 조합하여 8자 이상 작성해주세요." };
			} else {
				return { isError: false, message: "멋진 아이디이군요!" };
			}
		}

		// 이메일 유효성 검사
		function checkValidationForEmail() {
			const regEmail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
			const emailInputElement = document.getElementById("email");

			if (emailInputElement.value === "") {
				return { isError: true, message: "필수 입력 항목입니다!" };
			} else if (!regEmail.test(emailInputElement.value)) {
				return { isError: true, message: "올바른 메일 형식이 아닙니다!" };
			} else {
				return { isError: false, message: "올바른 메일 형식입니다!" };
			}
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
				return { isError: false, message: "안전한 비밀번호입니다!" };
			}
		}

		// 비밀번호 확인 유효성 검사
		function checkValidationForPasswordConfirm() {
			const passwordConfirmInputElement = document.getElementById("passwordConfirm");

			if (passwordConfirmInputElement.value === "") {
				return { isError: true, message: "비밀번호를 입력해주세요!" };
			} else if (passwordConfirmInputElement.value !== document.getElementById("password").value) {
				return { isError: true, message: "비밀번호가 일치하지 않습니다." };
			} else {
				return { isError: false, message: "비밀번호가 일치합니다." };
			}
		}

		// 생년월일 유효성 검사
		function checkValidationForBirthDate() {
			const birthDateInputElement = document.getElementById("birthDate");

			if (birthDateInputElement.value === "") {
				return { isError: true, message: "필수 입력 항목입니다!" };
			} else {
				return { isError: false, message: "올바른 생년월일입니다!" };
			}
		}

		// 휴대폰 번호 유효성 검사
		function checkValidationForPhoneNumber() {
			const regPhoneNumber = /^[0-9]{3}-[0-9]{3,4}-[0-9]{4}$/;
			const phoneNumberInputElement = document.getElementById("phoneNumber");

			if (phoneNumberInputElement.value === "") {
				return { isError: true, message: "필수 입력 항목입니다!" };
			} else if (!regPhoneNumber.test(phoneNumberInputElement.value)) {
				return { isError: true, message: "올바른 휴대폰 번호 형식이 아닙니다!" };
			} else {
				return { isError: false, message: "올바른 휴대폰 번호입니다!" };
			}
		}

		// 이름 유효성 검사
		function validateName() {
			const result = checkValidationForName();
			document.getElementById("nameCheck").innerText = result.message;
		}

		// 아이디 유효성 검사
		function validateId() {
			const result = checkValidationForId();
			document.getElementById("idCheck").innerText = result.message;
		}

		// 이메일 유효성 검사
		function validateEmail() {
			const result = checkValidationForEmail();
			document.getElementById("emailCheck").innerText = result.message;
		}

		// 비밀번호 유효성 검사
		function validatePassword() {
			const result = checkValidationForPassword();
			document.getElementById("passwordCheck").innerText = result.message;
		}

		// 비밀번호 확인 유효성 검사
		function validatePasswordConfirm() {
			const result = checkValidationForPasswordConfirm();
			document.getElementById("passwordConfirmCheck").innerText = result.message;
		}

		// 생년월일 유효성 검사
		function validateBirthDate() {
			const result = checkValidationForBirthDate();
			document.getElementById("birthDateCheck").innerText = result.message;
		}

		// 휴대폰 번호 유효성 검사
		function validatePhoneNumber() {
			const result = checkValidationForPhoneNumber();
			document.getElementById("phoneNumberCheck").innerText = result.message;
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

		// 회원가입 버튼 클릭 핸들러
		function handleSignUpButtonClick() {
			const nameValidation = checkValidationForName();
			const idValidation = checkValidationForId();
			const emailValidation = checkValidationForEmail();
			const passwordValidation = checkValidationForPassword();
			const passwordConfirmValidation = checkValidationForPasswordConfirm();
			const birthDateValidation = checkValidationForBirthDate();
			const phoneNumberValidation = checkValidationForPhoneNumber();

			document.getElementById("nameCheck").innerText = nameValidation.message;
			document.getElementById("idCheck").innerText = idValidation.message;
			document.getElementById("emailCheck").innerText = emailValidation.message;
			document.getElementById("passwordCheck").innerText = passwordValidation.message;
			document.getElementById("passwordConfirmCheck").innerText = passwordConfirmValidation.message;
			document.getElementById("birthDateCheck").innerText = birthDateValidation.message;
			document.getElementById("phoneNumberCheck").innerText = phoneNumberValidation.message;

			if (
				!nameValidation.isError &&
				!idValidation.isError &&
				!emailValidation.isError &&
				!passwordValidation.isError &&
				!passwordConfirmValidation.isError &&
				!birthDateValidation.isError &&
				!phoneNumberValidation.isError
			) {
				window.location.href = "/login.jsp";
			}
		}

	
	</script>
</body>
</html>
