function main() {
	if (!gad.getSession('login') || !gad.getSession('password'))
        location.href = 'login.html';
}
