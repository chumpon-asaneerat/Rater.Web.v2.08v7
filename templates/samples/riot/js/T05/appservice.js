class UnitTest {
    delay(t, v) {
        return new Promise(function (resolve) {
            setTimeout(resolve.bind(null, v), t)
        });
    };
    //-- Example of Promise.
    /*
    willIGetNewPhone = new Promise(function (resolve, reject) {
        if (isMomHappy) {
            var phone = {
                brand: 'Samsung',
                color: 'black'
            };
            resolve(phone); // fulfilled
        }
        else {
            var reason = new Error('mom is not happy');
            reject(reason); // reject
        }
    });
    */
}

// The UserService class.
class UserService {
    //-- constructor.
    constructor() {
        this._selectedUser = null;
    };

    //-- private methods.
    __getUsers() {
        let users = [{
            "userId": "M00001",
            "FullNameNative": "Mr. Test User.",
            "userName": "test@test.co.th", "passWord": "1234",
            "customerId": "EDL-2008050001", 
            "CustomerName": "Test Company 1"
        },
        {
            "userId": "M00001",
            "FullNameNative": "Mr. Test User.",
            "userName": "test@test.co.th", "passWord": "1234",
            "customerId": "EDL-2008050002", 
            "CustomerName": "Test Company 2"
        },
        {
            "userId": "M00001",
            "FullNameNative": "Mr. Admin User.",
            "userName": "admin@super-power.co.th", "passWord": "1234", 
            "customerId": "EDL-2008050003", 
            "CustomerName": "Super Power Company"
        },
        {
            "userId": "M00001",
            "FullNameNative": "Mr. Chumpon Asaneerat",
            "userName": "chumpon@softbase.co.th", "passWord": "1234",
            "customerId": "EDL-2008050004", 
            "CustomerName": "Softbase Company"
        }];
        return users;
    }

    //-- public method.
    signin(user) {
        // filter function.
        let isMatchUser = (item) => {
            // need to check case sensitive.
            let nameEq = item.userName === user.userName;
            let pwdEq = item.passWord === user.passWord;
            return (nameEq && pwdEq);
        };

        let formatUser = (item) => {
            // need to check case sensitive.
            // Hide some secure data like username, password.
            return { 
                "userId": item.userId,
                "FullNameNative": item.FullNameNative,
                "customerId": item.customerId,
                "CustomerName": item.CustomerName,
            };
        };

        // test@test.co.th
        // admin@super-power.co.th
        // chumpon@softbase.co.th
        let users = this.__getUsers();

        let fn = (resolve, reject) => {
            setTimeout(() => {
                let foundUsers = users.filter(isMatchUser).map(formatUser);
                resolve(foundUsers);
            }, 1000);
        };

        return new Promise(fn);
    };

    get selectedUser() {
        return this._selectedUser;
    };
    set selectedUser(value) {
        // some checking reqired.
        this._selectedUser = value;
    };
}

class App {
    constructor() {
        this._userService = new UserService();
    }

    //-- public properties.
    get userService() {
        return this._userService;
    }
}

; (function () {
    // set global app variable in window.
    window.app = window.app || new App();

    riot.compile(function () {
        var tags = riot.mount('*');
    });
})();