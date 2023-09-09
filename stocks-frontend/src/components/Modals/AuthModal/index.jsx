import { useState } from 'react';
import axios from 'axios';
import Modal from 'react-bootstrap/Modal';
import { useNavigate } from 'react-router-dom';
import Spinner from '../../Spinner'

import './authModal.css'
import { useApiUrl } from '../../../ApiContext';

function AuthModal(props){
    const {currentUser, setCurrentUser, showLogin, setShowLogin, showSignup, setShowSignup, setTraders, showCreateTrader, setShowCreateTrader } = props;

    const navigate = useNavigate();

    const apiUrl = useApiUrl();
    
    const [loading, setLoading] = useState(false);
    const [currentUserType, setCurrentUserType] = useState("admin");
    const [loginFormData, setLoginFormData] = useState({
        email: '',
        password: ''
    })
     const [signupFormData, setSignupFormData] = useState({
        first_name: '',
        last_name: '',
        email: '',
        password: '',
        password_confirmation: ''
    })

    const handleChange = (e, formSetter) => {
        const {name, value} = e.target;
        formSetter((prevFormData) => ({
            ...prevFormData,
            [name]: value
        }));
    };

    const handleLogin = async (e) => {
        e.preventDefault();
        setLoading(true);

        try{
            const response = await axios.post(`${apiUrl}/${currentUserType}/login`, loginFormData);
            const data = response.data;
            setCurrentUser({...data[currentUserType], token: data.token, role: currentUserType})
            alert('Signed in Successfully!');
            setLoginFormData({
                email: '',
                password: ''
            })
            if(data.admin){
                navigate('/admin');
            }else {
                navigate('/trader')
            }
            setLoading(false)
            setShowLogin(false);
        }catch(error){
            setLoading(false);
            alert(error.response.data.error);
        }
    }

    const handleSignup = async (e) => {
        e.preventDefault();

        try{
            const response = await axios.post(`${apiUrl}/trader/signup`, 
            {
                trader: signupFormData
            });
            const data = response.data;
            alert('Signup was successful. Please check your email');
            setSignupFormData({
                first_name: '',
                last_name: '',
                email: '',
                password: '',
                password_confirmation: ''
            })
            setShowSignup(false);
        }catch(error){
            alert(error.response.data.errors[0]);
        }
    }

    const createTrader = async (e) => {
        e.preventDefault();

        try{
            const token = currentUser.token
            const response = await axios.post(`${apiUrl}/admin/traders`,
            {
                trader: signupFormData
            },
            {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            })
            const data = response.data;
            alert('Trader Account Created.');
            setTraders((prevTraders) => [...prevTraders, data]);
            setSignupFormData({
                first_name: '',
                last_name: '',
                email: '',
                password: '',
                password_confirmation: ''
            })
            setShowCreateTrader(false);
        }catch(error){
            alert(error.response.data.errors[0]);
        }
    }
        
    return(
        <>
        {loading ? (
            <Spinner />
        ) : null}

        {/* SIGN IN */}
        <Modal show={showLogin} onHide={() => setShowLogin(false)} className='modal'>
            <Modal.Header className='modal_header'>
                <h2>
                    Sign In as {currentUserType === 'admin' ? "admin" : "trader"}
                </h2>
                <div className="swtich_btns">
                    <button onClick={() => setCurrentUserType("admin")} className='btns btn_primary signup_btn'>
                        Sign In as Admin
                    </button>
                    <button onClick={() => setCurrentUserType("trader")} className='btns btn_primary signup_btn'>
                        Sign In as Trader
                    </button>
                </div>
            </Modal.Header>
            <form onSubmit={handleLogin}>
                <Modal.Body className='modal_body'>
                    <input
                        type="email"
                        name="email"
                        value={loginFormData.email}
                        onChange={(e) => handleChange(e, setLoginFormData)}
                        required
                        placeholder="Email Address"
                    />
                    <input 
                        type="password"
                        name="password"
                        value={loginFormData.password}
                        onChange={(e) => handleChange(e, setLoginFormData)}
                        required
                        placeholder="Password"
                    />
                </Modal.Body>
                
                <Modal.Footer>
                    <button type='submit' className='btns btn_secondary' onClick={handleLogin}>Sign In</button>
                </Modal.Footer>
            </form>
        </Modal>

        {/* SIGN UP */}
        <Modal show={showSignup} onHide={() => setShowSignup(false)} className='modal'>
            <form onSubmit={handleSignup}>
                <Modal.Header closeButton>
                    <h2>
                        Create Trader Account
                    </h2>
                </Modal.Header>
                <Modal.Body className='modal_body'>
                    <input
                        type="text"
                        name="first_name"
                        value={signupFormData.first_name}
                        onChange={(e) => handleChange(e, setSignupFormData)}
                        required
                        placeholder="First Name"
                    />
                    <input
                        type="text"
                        name="last_name"
                        value={signupFormData.last_name}
                        onChange={(e) => handleChange(e, setSignupFormData)}
                        required
                        placeholder="Last Name"
                    />
                    <input
                        type="email"
                        name="email"
                        value={signupFormData.email}
                        onChange={(e) => handleChange(e, setSignupFormData)}
                        required
                        placeholder="Email Address"
                    />
                    <input
                        type="password"
                        name="password"
                        value={signupFormData.password}
                        onChange={(e) => handleChange(e, setSignupFormData)}
                        required
                        placeholder="Password"
                    />
                    <input
                        type="password"
                        name="password_confirmation"
                        value={signupFormData.password_confirmation}
                        onChange={(e) => handleChange(e, setSignupFormData)}
                        required
                        placeholder="Confirm Password"
                    />
                </Modal.Body>
                <Modal.Footer>
                    <button type='submit' onClick={handleSignup} className='btns btn_secondary'>Sign Up</button>
                </Modal.Footer>
            </form>
        </Modal>

        {/* CREATE ACCOUNT */}
        <Modal show={showCreateTrader} onHide={() => setShowCreateTrader(false)} className='modal'>
            <form onSubmit={createTrader}>
                <Modal.Header closeButton>
                    <h2>
                        Create Trader Account (Admin)
                    </h2>
                </Modal.Header>
                <Modal.Body className='modal_body'>
                    <input
                        type="text"
                        name="first_name"
                        value={signupFormData.first_name}
                        onChange={(e) => handleChange(e, setSignupFormData)}
                        required
                        placeholder="First Name"
                    />
                    <input
                        type="text"
                        name="last_name"
                        value={signupFormData.last_name}
                        onChange={(e) => handleChange(e, setSignupFormData)}
                        required
                        placeholder="Last Name"
                    />
                    <input
                        type="email"
                        name="email"
                        value={signupFormData.email}
                        onChange={(e) => handleChange(e, setSignupFormData)}
                        required
                        placeholder="Email Address"
                    />
                    <input
                        type="password"
                        name="password"
                        value={signupFormData.password}
                        onChange={(e) => handleChange(e, setSignupFormData)}
                        required
                        placeholder="Password"
                    />
                    <input
                        type="password"
                        name="password_confirmation"
                        value={signupFormData.password_confirmation}
                        onChange={(e) => handleChange(e, setSignupFormData)}
                        required
                        placeholder="Confirm Password"
                    />
                </Modal.Body>
                <Modal.Footer>
                    <button type='submit' onClick={createTrader} className='btns btn_secondary'>Create Account</button>
                </Modal.Footer>
            </form>
        </Modal>
        </>
    )
}

export default AuthModal;