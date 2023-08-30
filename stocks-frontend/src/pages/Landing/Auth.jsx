function Auth() {
    const [formData, setFormData] = useState({
        email: '',
        password: ''
    })
    const [currentUserType, setCurrentUserType] = useState("admin");

    const handleChange = (e) => {
        const {name, value} = e.target;
        setFormData((prevFormData) => ({
            ...prevFormData,
            [name]: value
        }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        try{
            const response = await axios.post(`http://localhost:3000/${currentUserType}/login`, formData);
            const data = response.data;
            setCurrentUser({...data[currentUserType], token: data.token})
            console.log(data);
            alert('Signed in Successfully!');
            setFormData({
                email: '',
                password: ''
            })
        }catch(error){
            console.error(error.response.data.error);
        }
    }

    // const handleLogout = () => {
    //     setCurrentUser(null);
    //     setCurrentUserType('admin');
    // }

    return(
        <>
        <h1>Login as {currentUserType === 'admin' ? "admin" : "trader"}</h1>
        <div className="btns_grp">
            <button onClick={() => setCurrentUserType("admin")}>Login as Admin</button>
            <button onClick={() => setCurrentUserType("trader")}>Login as Trader</button>
        </div>
        <form onSubmit={handleSubmit}>
            <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                required
                placeholder="Email Address"
            />
            <input 
                type="password"
                name="password"
                value={formData.password}
                onChange={handleChange}
                required
                placeholder="Password"
            />

            <button type="submit">Enter</button>
        </form>

        <button onClick={handleLogout}>Log out</button>
        </>
    )
}

export default Auth;