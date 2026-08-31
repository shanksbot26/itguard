import cn from 'clsx';
import s from './styles.module.pcss';

type Props = {
    id?: string;
    class?: string;
};

export const Logo = (props: Props) => {
    return (
        <div class={cn(s.logoContainer, props.class)}>
            <img src="/assets/logo.png" alt="ITGUARD" class={s.logoImg} />
            <span class={s.logoText}>
                <span class={s.logoTextRed}>IT</span>GUARD
            </span>
        </div>
    );
};
